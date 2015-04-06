//
//  StoreViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "StoreViewController.h"

//部位类型
typedef NS_ENUM(NSInteger, PartType) {
    PartTypeHair = 100,
    PartTypeEye = 101,
    PartTypeMouth = 102,
    PartTypeClothes = 103
};

static CGFloat const FatGuyHeightRatio = 0.8f;          //外框对于背景的比例
static CGFloat const typeScrollViewHeight = 30.0f;      //类型选择框的高度
static CGFloat const pictureScrollViewHeight = 120.0f;  //图片选择框的高度
static NSInteger const pictureScrollViewColumn = 4;     //列数
static NSInteger const pictureScrollViewRow = 2;        //行数
static CGFloat const pictureButtonLeftPadding = 30.0f;  //图片的左间距
static CGFloat const pictureButtonTopPadding = 10.0f;   //图片的上间距
static NSInteger const pictureButtonTag = 50;           //图片的起始tag


@interface StoreViewController ()

@property(nonatomic, assign) PartType partType;                 //选择的类型
@property(nonatomic, strong) UIScrollView *partTypeScrollView;  //类型滑动条
@property(nonatomic, strong) UIScrollView *partPictScrollView;  //内容滑动条

@property(nonatomic, strong) UIImageView *hairImage;            //图片框
@property(nonatomic, strong) UIImageView *eyeImage;
@property(nonatomic, strong) UIImageView *mouthImage;
@property(nonatomic, strong) UIImageView *clothesImage;

@property(nonatomic, assign) NSInteger  hairChoice;             //选择的序号
@property(nonatomic, assign) NSInteger  eyeChoice;
@property(nonatomic, assign) NSInteger  mouthChoice;
@property(nonatomic, assign) NSInteger  clothesChoice;

@property(nonatomic, strong) NSDictionary *dict;                //查到的数据
@property(nonatomic, strong) NSMutableArray *partPictArray;//几经思考，决定存状态，0表示未买，1表示已买，2表示选中

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"NavBackIcon"] forState:UIControlStateNormal];
    [leftBtn setTitle:@"保存" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    leftBtn.frame = CGRectMake(0, 0, 80, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT);
    [leftBtn addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.title = @"商店";
    
    CGFloat fatGuyViewHeight = APPCONFIG_UI_SCREEN_VHEIGHT - typeScrollViewHeight - pictureScrollViewHeight;
    UIView* fatGuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, fatGuyViewHeight)];
    [fatGuyView setBackgroundColor:themePureBlueColor];
    [self.view addSubview:fatGuyView];
    
    //金币框
    
    
    //加两个云，这里frame就写死了
    UIImageView *cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(210, 5, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [fatGuyView addSubview:cloudImage];
    
    cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(260, 45, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [fatGuyView addSubview:cloudImage];
    
    //胖子框
    UIView *fatGuyFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fatGuyViewHeight * FatGuyHeightRatio, fatGuyViewHeight * FatGuyHeightRatio)];
    [fatGuyFrameView setBackgroundColor:[UIColor whiteColor]];
    [fatGuyFrameView setCenter:CGPointMake(fatGuyView.center.x, fatGuyView.center.y + APPCONFIG_UI_VIEW_BETWEEN_PADDING)];
    fatGuyFrameView.layer.cornerRadius = fatGuyViewHeight * FatGuyHeightRatio / 2.0f;
    fatGuyFrameView.layer.shadowColor = themeDeepBlueColor.CGColor;
    fatGuyFrameView.layer.shadowOffset = CGSizeMake(5, 5);
    fatGuyFrameView.layer.shadowOpacity = 1;
    fatGuyFrameView.layer.shadowRadius = 0;
    [fatGuyView addSubview:fatGuyFrameView];

    //获取等级和配件
    NSError *error;
    _dict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    _hairChoice = [_dict[@"hair"] integerValue];
    _eyeChoice = [_dict[@"eye"] integerValue];
    _mouthChoice = [_dict[@"mouth"] integerValue];
    _clothesChoice = [_dict[@"clothes"] integerValue];
    
    //体型
    NSString *bodyImageUrl = [NSString stringWithFormat:@"body_%@_%@",_dict[@"gender"], _dict[@"level"]];
    UIImageView *bodyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bodyImageUrl]];
    [bodyImage setCenter:CGPointMake(fatGuyFrameView.width / 2.0f, fatGuyFrameView.height / 2.0f)];
    [fatGuyFrameView addSubview:bodyImage];
    
    //发型
    NSString *hairImageUrl = [NSString stringWithFormat:@"hair_%@", _dict[@"hair"]];
    _hairImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hairImageUrl]];
    _hairImage.center = CGPointMake(fatGuyFrameView.width / 2.0f + 3.0f, 38.0f);
    [fatGuyFrameView addSubview:_hairImage];
    
    //眼睛
    NSString *eyeImageUrl = [NSString stringWithFormat:@"eye_%@", _dict[@"eye"]];
    _eyeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:eyeImageUrl]];
    _eyeImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, 54.0f);
    [fatGuyFrameView addSubview:_eyeImage];
    
    //嘴巴
    NSString *mouthImageUrl = [NSString stringWithFormat:@"mouth_%@", _dict[@"mouth"]];
    _mouthImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:mouthImageUrl]];
    _mouthImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, 80.0f);
    [fatGuyFrameView addSubview:_mouthImage];
    
    //衣服
    NSString *clothesImageUrl = [NSString stringWithFormat:@"clothes_%@_%@", _dict[@"clothes"], _dict[@"level"]];
    _clothesImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:clothesImageUrl]];
    _clothesImage.center = CGPointMake(fatGuyFrameView.width / 2.0f, 136.0f);
    [fatGuyFrameView addSubview:_clothesImage];
    
    //部件类型
    _partTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, typeScrollViewHeight)];
    _partTypeScrollView.backgroundColor = [UIColor whiteColor];
    _partTypeScrollView.contentSize = CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH + 1.0f, typeScrollViewHeight);//让他能动
    _partTypeScrollView.showsVerticalScrollIndicator = NO;
    [_partTypeScrollView bottomOfView:fatGuyView];
    [self.view addSubview:_partTypeScrollView];
    
    CGFloat partTypeBtnWidth = APPCONFIG_UI_SCREEN_FWIDTH / 4.0f;
    UIButton *hairTypeBtn = [self createPartTypeButton];
    hairTypeBtn.frame = CGRectMake(0, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [hairTypeBtn setTitle:@"发型" forState:UIControlStateNormal];
    [hairTypeBtn setTag:PartTypeHair];
    [_partTypeScrollView addSubview:hairTypeBtn];
    
    UIButton *eyeTypeBtn = [self createPartTypeButton];
    eyeTypeBtn.frame = CGRectMake(partTypeBtnWidth, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [eyeTypeBtn setTitle:@"眼睛" forState:UIControlStateNormal];
    [eyeTypeBtn setTag:PartTypeEye];
    [_partTypeScrollView addSubview:eyeTypeBtn];
    
    UIButton *mouthTypeBtn = [self createPartTypeButton];
    mouthTypeBtn.frame = CGRectMake(partTypeBtnWidth * 2, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [mouthTypeBtn setTitle:@"嘴巴" forState:UIControlStateNormal];
    [mouthTypeBtn setTag:PartTypeMouth];
    [_partTypeScrollView addSubview:mouthTypeBtn];
    
    UIButton *clothesTypeBtn = [self createPartTypeButton];
    clothesTypeBtn.frame = CGRectMake(partTypeBtnWidth * 3, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [clothesTypeBtn setTitle:@"衣服" forState:UIControlStateNormal];
    [clothesTypeBtn setTag:PartTypeClothes];
    [_partTypeScrollView addSubview:clothesTypeBtn];
    
    //部件滑动框
    _partPictScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, pictureScrollViewHeight)];
    _partPictScrollView.backgroundColor = indexBackgroundColor;
    _partPictScrollView.contentSize = CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH + 1.0f, pictureScrollViewHeight);//让他能动
    _partPictScrollView.showsVerticalScrollIndicator = NO;
    _partPictScrollView.pagingEnabled = YES;
    [_partPictScrollView bottomOfView:_partTypeScrollView];
    [self.view addSubview:_partPictScrollView];
    
    //初始选中发型
    [self tappedTypeButton:hairTypeBtn];
}

#pragma mark - 附加方法
- (UIButton *)createPartTypeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setExclusiveTouch:YES];
    [button setTitleColor:tipTitleLabelColor forState:UIControlStateSelected];
    [button setTitleColor:saveTextGreyColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [button addTarget:self action:@selector(tappedTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSMutableArray *)createPartPictArrayWithNum:(NSInteger)count {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [array addObject:[NSNumber numberWithInt:1]];
    }
    return array;
}

- (void)pushBack {
    //保存
    NSError *error;
    [AccountCoreDataHelper setDataByName:@"hair" andData:[NSString getFromInteger:_hairChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"eye" andData:[NSString getFromInteger:_eyeChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"mouth" andData:[NSString getFromInteger:_mouthChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"clothes" andData:[NSString getFromInteger:_clothesChoice] withError:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击事件
// 点击类型按钮
- (void)tappedTypeButton:(UIButton *)button {
    UIButton *tmpButton;
    if (self.partType) {
        tmpButton = (UIButton *)[_partTypeScrollView viewWithTag:self.partType];
        tmpButton.selected = !tmpButton.selected;
    }
    
    self.partType = button.tag;
    tmpButton = (UIButton *)[_partTypeScrollView viewWithTag:self.partType];
    tmpButton.selected = !tmpButton.selected;
    
    //先清空所有内容
    [_partPictScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //根据类型加按钮
    NSString *typeString;//保存一个类型字符串
    switch (self.partType) {
        case PartTypeHair:
            _partPictArray = [self createPartPictArrayWithNum:5];
            typeString = @"hair";
            _partPictArray[[_dict[typeString] integerValue]] = [NSNumber numberWithInt:2];
            break;
        case PartTypeEye:
            _partPictArray = [self createPartPictArrayWithNum:8];
            typeString = @"eye";
            _partPictArray[[_dict[typeString] integerValue]] = [NSNumber numberWithInt:2];
            break;
        case PartTypeMouth:
            _partPictArray = [self createPartPictArrayWithNum:6];
            typeString = @"mouth";
            _partPictArray[[_dict[typeString] integerValue]] = [NSNumber numberWithInt:2];
            break;
        case PartTypeClothes:
            _partPictArray = [self createPartPictArrayWithNum:1];
            typeString = @"clothes";
            _partPictArray[[_dict[typeString] integerValue]] = [NSNumber numberWithInt:2];
            break;
        default:
            break;
    }
    if (!_partPictArray || _partPictArray.count == 0) {
        return;
    }
    NSInteger status = 0, row = 0, column = 0, page = 0;;
    CGFloat pictButtonWidth = (APPCONFIG_UI_SCREEN_FWIDTH - pictureButtonLeftPadding * (pictureScrollViewColumn + 1)) / pictureScrollViewColumn;
    NSString *pictUrl;
    for (int i = 0; i < _partPictArray.count; i++) {
        status = [_partPictArray[i] integerValue];
        if (self.partType == PartTypeClothes) {
            pictUrl = [NSString stringWithFormat:@"%@_%d_%@", typeString, i, _dict[@"level"]];
        } else {
            pictUrl = [NSString stringWithFormat:@"%@_%d", typeString, i];
        }
        
        UIButton* pictButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pictButton.tag = pictureButtonTag + i;
        pictButton.backgroundColor = [UIColor whiteColor];
        pictButton.layer.cornerRadius = 12.0f;
        pictButton.layer.masksToBounds = YES;
        pictButton.layer.borderColor = themeBlueColor.CGColor;
        if (status == 2) {
            pictButton.layer.borderWidth = 1.0f;
        } else {
            pictButton.layer.borderWidth = 0.0f;
        }
        [pictButton setBackgroundImage:[UIImage imageNamed:pictUrl] forState:UIControlStateNormal];
        pictButton.frame = CGRectMake(page * _partPictScrollView.width + pictureButtonLeftPadding + column * (pictureButtonLeftPadding + pictButtonWidth), pictureButtonTopPadding + row * (pictureButtonTopPadding + pictButtonWidth), pictButtonWidth, pictButtonWidth);
        [pictButton addTarget:self action:@selector(tappedPictButton:) forControlEvents:UIControlEventTouchUpInside];
        [_partPictScrollView addSubview:pictButton];
        column ++;
        if (column >= pictureScrollViewColumn) {
            row ++;
            column = 0;
        }
        if (row >= pictureScrollViewRow) {
            page ++;
            row = 0;
            column = 0;
        }
    }
    
    if (row == 0 && column == 0) {
        _partPictScrollView.contentSize = CGSizeMake(_partPictScrollView.width * page + 1.0f, _partPictScrollView.height);
    } else {
        _partPictScrollView.contentSize = CGSizeMake(_partPictScrollView.width * (page + 1) + 1.0f, _partPictScrollView.height);
    }
}

- (void)tappedPictButton:(UIButton *)button {
    //先找到原先选中的
    NSInteger status = 0, index = 0;
    for (int i = 0; i < _partPictArray.count; i++) {
        status = [_partPictArray[i] integerValue];
        if (status == 2) {
            _partPictArray[i] = [NSNumber numberWithInt:1];
            status = i;
            break;
        }
    }
    status += pictureButtonTag;
    UIButton *tmpButton = (UIButton *)[_partPictScrollView viewWithTag:status];
    tmpButton.layer.borderWidth = 0.0f;
    //再设置现在为选中
    button.layer.borderWidth = 1.0f;
    index = button.tag - pictureButtonTag;
    _partPictArray[index] = [NSNumber numberWithInt:2];
    CGPoint center;
    switch (self.partType) {
        case PartTypeHair: {
            _hairChoice = index;
            
            NSString *hairImageUrl = [NSString stringWithFormat:@"hair_%ld", (long)index];
            center = _hairImage.center;
            _hairImage.image = [UIImage imageNamed:hairImageUrl];
            [_hairImage sizeToFit];
            _hairImage.center = center;
            break;
        }
        case PartTypeEye: {
            _eyeChoice = index;
            
            NSString *eyeImageUrl = [NSString stringWithFormat:@"eye_%ld", (long)index];
            center = _eyeImage.center;
            _eyeImage.image = [UIImage imageNamed:eyeImageUrl];
            [_eyeImage sizeToFit];
            _eyeImage.center = center;
            break;
        }
        case PartTypeMouth: {
            _mouthChoice = index;
            
            NSString *mouthImageUrl = [NSString stringWithFormat:@"mouth_%ld", (long)index];
            center = _mouthImage.center;
            _mouthImage.image = [UIImage imageNamed:mouthImageUrl];
            [_mouthImage sizeToFit];
            _mouthImage.center = center;
            break;
        }
        case PartTypeClothes: {
            _clothesChoice = index;
            
            NSString *clothesImageUrl = [NSString stringWithFormat:@"clothes_%ld_%@", (long)index, _dict[@"level"]];
            center = _clothesImage.center;
            _clothesImage.image = [UIImage imageNamed:clothesImageUrl];
            [_clothesImage sizeToFit];
            _clothesImage.center = center;
            break;
        }
        default:
            break;
    }
}

@end
