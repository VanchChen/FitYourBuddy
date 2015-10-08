//
//  StoreViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/5.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "StoreViewController.h"
#import "Store.h"

static NSInteger const StorePartTypeTag = 200;          //部位起始tag
static NSInteger const pictureButtonTag = 50;           //图片的起始tag倍数

static CGFloat const FatGuyHeightRatio = 0.8f;          //外框对于背景的比例
static CGFloat const typeScrollViewHeight = 30.0f;      //类型选择框的高度
static CGFloat const pictureScrollViewHeight = 169.0f;  //图片选择框的高度
static NSInteger const pictureScrollViewColumn = 3;     //列数
static NSInteger const pictureScrollViewRow = 2;        //行数
static CGFloat const pictureButtonLeftPadding = 30.0f;  //图片的左间距
static CGFloat const pictureButtonTopPadding = 10.0f;   //图片的上间距
static CGFloat const pictureCoverButtonRatio = 0.2;     //金锁相对于父类的间隔比例
static UIEdgeInsets const coinFrameInset = (UIEdgeInsets){10,5,40,90};  //金币框边距，分别为（上，左，高，宽）
static UIEdgeInsets const coinImageInset = (UIEdgeInsets){5,5,40,40};  //金币图片边距，分别为（上，左，高，宽）
static UIEdgeInsets const popViewInset = (UIEdgeInsets){0,0,180,280};  //购买框，分别为（上，左，高，宽）
static CGFloat const popTipLabelHeight = 30.0f;         //弹出框提示的高度
static CGFloat const buyButtonWidth = 150.0f;           //购买按钮的宽度
static CGFloat const buyButtonHeight = 40.0f;           //购买按钮的高度

static CGFloat  const IPhone4sRatio = 217.0f / 305.0f;

@interface StoreImageView : UIImageView

@end

@implementation StoreImageView

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    
    CGRect frame = self.frame;
    CGFloat centerX = 0.0, centerY = 0.0;
    if (frame.origin.x > 0) {
        centerX = frame.origin.x + frame.size.width / 2.0f;
        centerY = frame.origin.y + frame.size.height / 2.0f;
    }
    
    if (APPCONFIG_DEVICE_OVER_IPHONE5) {
        frame.size = image.size;
    } else {
        frame.size.width = image.size.width * IPhone4sRatio;
        frame.size.height = image.size.height * IPhone4sRatio;
    }
    
    if (frame.origin.x > 0) {
        frame.origin.x = centerX - frame.size.width / 2.0f;
        frame.origin.y = centerY - frame.size.height / 2.0f;
    }
    
    self.frame = frame;
}

@end

@interface StoreViewController () <UIScrollViewDelegate>

@property(nonatomic, assign) StoreType storeType;               //选择的类型
@property(nonatomic, strong) UIView* fatGuyView;                //胖砸框
@property(nonatomic, strong) UIScrollView *partTypeScrollView;  //类型滑动条
@property(nonatomic, strong) UIScrollView *partPictScrollView;  //内容滑动条

@property(nonatomic, strong) UILabel *coinLabel;                //金币框

@property(nonatomic, strong) UIImageView *hairImage;            //图片框
@property(nonatomic, strong) StoreImageView *eyeImage;
@property(nonatomic, strong) StoreImageView *mouthImage;
@property(nonatomic, strong) UIImageView *clothesImage;

@property(nonatomic, assign) NSInteger  hairChoice;             //选择的序号
@property(nonatomic, assign) NSInteger  eyeChoice;
@property(nonatomic, assign) NSInteger  mouthChoice;
@property(nonatomic, assign) NSInteger  clothesChoice;

@property(nonatomic, assign) NSInteger  coinCount;              //金币数

@property(nonatomic, strong) NSDictionary *dict;                //查到的数据
@property(nonatomic, strong) NSMutableArray *partPictArray;//几经思考，决定存状态，0表示未买，1表示已买，2表示选中

@end

@implementation StoreViewController
#pragma mark - 生命周期

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商店"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"商店"];
}

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
    
    [self initFatguyView];
    [self initScrollView];
}

- (void)initFatguyView {
    NSError *error; //先取数据库
    _dict = [AccountCoreDataHelper getAccountDictionaryWithError:&error];
    
    CGFloat fatGuyViewHeight = APPCONFIG_UI_SCREEN_FHEIGHT - APPCONFIG_UI_STATUSBAR_HEIGHT - APPCONFIG_UI_NAVIGATIONBAR_HEIGHT - typeScrollViewHeight - pictureScrollViewHeight;
    _fatGuyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, fatGuyViewHeight)];
    [_fatGuyView setBackgroundColor:themePureBlueColor];
    [self.view addSubview:_fatGuyView];
    
    //金币框
    _coinCount = [_dict[@"coin"] integerValue];
    UIView *coinFrameView = [CommonUtil createView];
    coinFrameView.layer.borderColor = themeDeepBlueColor.CGColor;
    coinFrameView.layer.cornerRadius = 10;
    coinFrameView.frame = CGRectMake(coinFrameInset.left, coinFrameInset.top, coinFrameInset.right, coinFrameInset.bottom);
    [_fatGuyView addSubview:coinFrameView];
    
    UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(coinImageInset.left, coinImageInset.top, coinFrameView.height - coinImageInset.top * 2, coinFrameView.height - coinImageInset.top * 2)];
    coinImageView.image = [UIImage imageNamed:@"CoinIcon"];
    [coinFrameView addSubview:coinImageView];
    
    _coinLabel = [CommonUtil createLabelWithText:_dict[@"coin"] andTextColor:themeOrangeColor andFont:[UIFont systemFontOfSize:16.0] andTextAlignment:NSTextAlignmentCenter];
    _coinLabel.frame = CGRectMake(coinImageInset.left + coinImageView.width, 0, coinFrameView.width - coinImageInset.left - coinImageView.width, coinFrameView.height);
    [coinFrameView addSubview:_coinLabel];
    
    //加两个云，这里frame就写死了
    UIImageView *cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(210, 5, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [_fatGuyView addSubview:cloudImage];
    
    cloudImage = [[UIImageView alloc] init];
    cloudImage.frame = CGRectMake(260, 45, 60, 60);
    cloudImage.image = [UIImage imageNamed:@"CloudIcon"];
    [_fatGuyView addSubview:cloudImage];
    
    //胖子框
    UIView *fatGuyFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fatGuyViewHeight * FatGuyHeightRatio, fatGuyViewHeight * FatGuyHeightRatio)];
    [fatGuyFrameView setBackgroundColor:[UIColor whiteColor]];
    [fatGuyFrameView setCenter:CGPointMake(_fatGuyView.center.x, _fatGuyView.center.y + APPCONFIG_UI_VIEW_BETWEEN_PADDING)];
    fatGuyFrameView.layer.cornerRadius = fatGuyViewHeight * FatGuyHeightRatio / 2.0f;
    fatGuyFrameView.layer.shadowColor = themeDeepBlueColor.CGColor;
    fatGuyFrameView.layer.shadowOffset = CGSizeMake(5, 5);
    fatGuyFrameView.layer.shadowOpacity = 1;
    fatGuyFrameView.layer.shadowRadius = 0;
    [_fatGuyView addSubview:fatGuyFrameView];
    
    //获取等级和配件
    _hairChoice = [_dict[@"hair"] integerValue];
    _eyeChoice = [_dict[@"eye"] integerValue];
    _mouthChoice = [_dict[@"mouth"] integerValue];
    _clothesChoice = [_dict[@"clothes"] integerValue];
    
    UIImage *bodyImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"body_%@_%@",_dict[@"gender"], _dict[@"level"]]];
    UIImage *eyeImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%@",_dict[@"gender"], _dict[@"eye"]]];
    UIImage *mouthImagePict = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%@",_dict[@"gender"], _dict[@"mouth"]]];
    CGFloat eyeGap, mouthGap;
    if (!APPCONFIG_DEVICE_OVER_IPHONE5) {
        eyeGap = 43;
        mouthGap = 61;
    } else {
        eyeGap = 60;
        mouthGap = 85;
    }
    
    //体型
    StoreImageView *bodyImage = [[StoreImageView alloc] init];
    [bodyImage setImage:bodyImagePict];
    [bodyImage setCenter:CGPointMake(fatGuyFrameView.width / 2.0f, fatGuyFrameView.height / 2.0f)];
    [fatGuyFrameView addSubview:bodyImage];
    
    //眼睛
    _eyeImage = [[StoreImageView alloc] init];
    [_eyeImage setImage:eyeImagePict];
    _eyeImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, eyeGap);
    //_eyeImage.contentMode = UIViewContentModeCenter;
    [fatGuyFrameView addSubview:_eyeImage];
    
    //嘴巴
    _mouthImage = [[StoreImageView alloc] init];
    [_mouthImage setImage:mouthImagePict];
    _mouthImage.center = CGPointMake(fatGuyFrameView.width / 2.0f - 1.0f, mouthGap);
    //_mouthImage.contentMode = UIViewContentModeCenter;
    [fatGuyFrameView addSubview:_mouthImage];
}

- (void)initScrollView {
    //部件类型
    _partTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, typeScrollViewHeight)];
    _partTypeScrollView.tag = 1000;//为了区分内部按钮的tag
    _partTypeScrollView.backgroundColor = [UIColor whiteColor];
    _partTypeScrollView.contentSize = CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH + 1.0f, typeScrollViewHeight);//让他能动
    _partTypeScrollView.showsVerticalScrollIndicator = NO;
    [_partTypeScrollView bottomOfView:_fatGuyView];
    [self.view addSubview:_partTypeScrollView];
    
    CGFloat partTypeBtnWidth = APPCONFIG_UI_SCREEN_FWIDTH / 4.0f;
//    UIButton *hairTypeBtn = [self createPartTypeButton];
//    hairTypeBtn.frame = CGRectMake(0, 0, partTypeBtnWidth, _partTypeScrollView.height);
//    [hairTypeBtn setTitle:@"发型" forState:UIControlStateNormal];
//    [hairTypeBtn setTag:(StorePartTypeTag + StoreTypeHair)];
//    [_partTypeScrollView addSubview:hairTypeBtn];
    
    UIButton *eyeTypeBtn = [self createPartTypeButton];
    eyeTypeBtn.frame = CGRectMake(0, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [eyeTypeBtn setTitle:@"眼睛" forState:UIControlStateNormal];
    [eyeTypeBtn setTag:(StorePartTypeTag + StoreTypeEye)];
    [_partTypeScrollView addSubview:eyeTypeBtn];
    
    UIButton *mouthTypeBtn = [self createPartTypeButton];
    mouthTypeBtn.frame = CGRectMake(partTypeBtnWidth, 0, partTypeBtnWidth, _partTypeScrollView.height);
    [mouthTypeBtn setTitle:@"嘴巴" forState:UIControlStateNormal];
    [mouthTypeBtn setTag:(StorePartTypeTag + StoreTypeMouth)];
    [_partTypeScrollView addSubview:mouthTypeBtn];
    
//    UIButton *clothesTypeBtn = [self createPartTypeButton];
//    clothesTypeBtn.frame = CGRectMake(partTypeBtnWidth * 3, 0, partTypeBtnWidth, _partTypeScrollView.height);
//    [clothesTypeBtn setTitle:@"衣服" forState:UIControlStateNormal];
//    [clothesTypeBtn setTag:(StorePartTypeTag + StoreTypeClothes)];
//    [_partTypeScrollView addSubview:clothesTypeBtn];
    
    //部件滑动框
    _partPictScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, pictureScrollViewHeight)];
    _partPictScrollView.tag = 1000;             //为了区分内部按钮的tag
    _partPictScrollView.delegate = self;
    _partPictScrollView.backgroundColor = indexBackgroundColor;
    _partPictScrollView.contentSize = CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH * 2, pictureScrollViewHeight);
    _partPictScrollView.showsVerticalScrollIndicator = NO;
    _partPictScrollView.showsHorizontalScrollIndicator = NO;
    _partPictScrollView.pagingEnabled = YES;
    [_partPictScrollView bottomOfView:_partTypeScrollView];
    [self.view addSubview:_partPictScrollView];
    
    //加载滑动框内容
    //[self createPartPictButtonByStoreType:StoreTypeHair andPage:0];
    [self createPartPictButtonByStoreType:StoreTypeEye andPage:0];
    [self createPartPictButtonByStoreType:StoreTypeMouth andPage:1];
    //[self createPartPictButtonByStoreType:StoreTypeClothes andPage:3];
    
    //点选第一个
    self.storeType = StoreTypeEye;
    eyeTypeBtn.selected = YES;
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

- (void)createPartPictButtonByStoreType:(StoreType)type andPage:(NSInteger)page {
    NSError *error;
    NSInteger row = 0, column = 0, index = 0;
    CGFloat pictButtonWidth = (APPCONFIG_UI_SCREEN_FWIDTH - pictureButtonLeftPadding * (pictureScrollViewColumn + 1)) / pictureScrollViewColumn;
    NSString *pictUrl;
    //取数据
    NSArray *contentArray = [StoreCoreDataHelper getArrayByStoreType:type andError:&error];
    if (!contentArray || contentArray.count == 0) {
        return;
    }
    
    NSString *typeString;//保存一个类型字符串
    switch (type) {
        case StoreTypeHair:
            typeString = @"hair";
            break;
        case StoreTypeEye:
            typeString = @"eye";
            break;
        case StoreTypeMouth:
            typeString = @"mouth";
            break;
        case StoreTypeClothes:
            typeString = @"clothes";
            break;
        default:
            break;
    }
    
    NSInteger selectedIndex = [_dict[typeString] integerValue];
    
    for (Store *entity in contentArray) {
        index = [entity.index integerValue];
        //添加按钮
        UIButton* pictButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pictButton.tag = pictureButtonTag * type + index;
        pictButton.backgroundColor = [UIColor whiteColor];
        pictButton.layer.cornerRadius = 12.0f;
        pictButton.layer.masksToBounds = YES;
        pictButton.layer.borderWidth = 2.0f;
        if (selectedIndex == index) {
            pictButton.layer.borderColor = themeBlueColor.CGColor;
        } else {
            pictButton.layer.borderColor = themeGreyColor.CGColor;
        }
        if (type == StoreTypeClothes) {
            pictUrl = [NSString stringWithFormat:@"%@_tn_%@_%ld_%@", typeString, _dict[@"gender"], (long)index, _dict[@"level"]];
        } else {
            pictUrl = [NSString stringWithFormat:@"%@_tn_%@_%ld", typeString, _dict[@"gender"], (long)index];
        }
        [pictButton setImage:[UIImage imageNamed:pictUrl] forState:UIControlStateNormal];
        //[pictButton setContentMode:UIViewContentModeScaleToFill];
        pictButton.frame = CGRectMake(page * _partPictScrollView.width + pictureButtonLeftPadding + column * (pictureButtonLeftPadding + pictButtonWidth), pictureButtonTopPadding + row * (pictureButtonTopPadding + pictButtonWidth), pictButtonWidth, pictButtonWidth);
        [pictButton addTarget:self action:@selector(tappedPictButton:) forControlEvents:UIControlEventTouchUpInside];
        [_partPictScrollView addSubview:pictButton];
        
        //处理是否购买
        if ([entity.hasBought integerValue] == 0) {//未购买
            UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
            coverButton.frame = pictButton.bounds;
            coverButton.backgroundColor = transparentBlackColor;
            [coverButton setImage:[UIImage imageNamed:@"LockIcon"] forState:UIControlStateNormal];
            [coverButton setImageEdgeInsets:UIEdgeInsetsMake(pictButtonWidth * pictureCoverButtonRatio, pictButtonWidth * pictureCoverButtonRatio, pictButtonWidth * pictureCoverButtonRatio, pictButtonWidth * pictureCoverButtonRatio)];
            [coverButton addTarget:self action:@selector(tappedCoverButton:) forControlEvents:UIControlEventTouchUpInside];
            [pictButton addSubview:coverButton];
        }
        
        //处理行列
        column ++;
        if (column >= pictureScrollViewColumn) {
            row ++;
            column = 0;
        }
        if (row >= pictureScrollViewRow) {
            break;
        }
    }
    
}

- (void)pushBack {
    //保存
    NSError *error;
    [AccountCoreDataHelper setDataByName:@"hair" andData:[NSString stringFromInteger:_hairChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"eye" andData:[NSString stringFromInteger:_eyeChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"mouth" andData:[NSString stringFromInteger:_mouthChoice] withError:&error];
    [AccountCoreDataHelper setDataByName:@"clothes" andData:[NSString stringFromInteger:_clothesChoice] withError:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击事件
// 点击类型按钮
- (void)tappedTypeButton:(UIButton *)button {
    //找到上一个，去掉他
    [self changeButtonSelectStatus];
    
    //选中当前
    self.storeType = button.tag - StorePartTypeTag;
    button.selected = !button.selected;
    
    //滚动页面
    NSInteger page = 0;
    if (self.storeType == StoreTypeMouth) {
        page = 1;
    }
    [_partPictScrollView setContentOffset:CGPointMake(_partTypeScrollView.width * page, 0) animated:YES];
}

- (void)tappedPictButton:(UIButton *)button {
    NSInteger index = 0, newIndex = button.tag - pictureButtonTag * self.storeType;
    
    //先找到原先选中的
    switch (self.storeType) {
        case StoreTypeHair:
            index = _hairChoice + pictureButtonTag * self.storeType;
            _hairChoice = newIndex;
            _hairImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"hair_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeEye:
            index = _eyeChoice + pictureButtonTag * self.storeType;
            _eyeChoice = newIndex;
            _eyeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeMouth:
            index = _mouthChoice + pictureButtonTag * self.storeType;
            _mouthChoice = newIndex;
            _mouthImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeClothes:
            index = _clothesChoice + pictureButtonTag * self.storeType;
            _clothesChoice = newIndex;
            _clothesImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"clothes_%@_%ld_%@", _dict[@"gender"], (long)newIndex, _dict[@"level"]]];
            break;
        default:
            break;
    }
    UIButton *tmpButton = (UIButton *)[_partPictScrollView viewWithTag:index];
    tmpButton.layer.borderColor = themeGreyColor.CGColor;
    
    //后设置现在为选中
    button.layer.borderColor = themeBlueColor.CGColor;
}

//根据当前类型改变按钮选中状态
- (void)changeButtonSelectStatus {
    UIView *tmpView = [_partTypeScrollView viewWithTag:(StorePartTypeTag + self.storeType)];
    if (tmpView && [tmpView isKindOfClass:[UIButton class]]) {
        UIButton *tmpButton = (UIButton *)tmpView;
        tmpButton.selected = !tmpButton.selected;
    }
}

- (void)tappedCoverButton:(UIButton *)button {
    NSInteger index = button.superview.tag - pictureButtonTag * self.storeType;
    
    NSError *error;
    NSInteger coin = [StoreCoreDataHelper getCoinCountByStoreType:self.storeType andIndex:index andError:&error];
    
    UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.frame = self.view.window.bounds;
    backgroundButton.backgroundColor = popBackgroundColor;
    [backgroundButton addTarget:self action:@selector(tappedCoverBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:backgroundButton];
    
    UIView *popView = [CommonUtil createView];
    popView.frame = CGRectMake((backgroundButton.width - popViewInset.right) / 2.0f, (backgroundButton.height - popViewInset.bottom) / 2.0f, popViewInset.right, popViewInset.bottom);
    popView.layer.borderColor = themeDeepBlueColor.CGColor;
    popView.layer.borderWidth = 2.0f;
    [backgroundButton addSubview:popView];
    
    UILabel *popTipLabel = [CommonUtil createLabelWithText:@"解锁该装扮需要" andTextColor:tipTitleLabelColor andFont:[UIFont systemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    popTipLabel.frame = CGRectMake(0, APPCONFIG_UI_VIEW_PADDING, popView.width, popTipLabelHeight);
    [popView addSubview:popTipLabel];
    
    UIImageView *popCoinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, coinImageInset.right, coinImageInset.bottom)];
    [popCoinImageView setImage:[UIImage imageNamed:@"CoinIcon"]];
    [popView addSubview:popCoinImageView];
    
    NSString *coinString = [NSString stringFromInteger:coin];
    UILabel *popCoinLabel = [CommonUtil createLabelWithText:coinString andTextColor:themeOrangeColor andFont:[UIFont systemFontOfSize:20] andTextAlignment:NSTextAlignmentCenter];
    [popView addSubview:popCoinLabel];
    
    CGSize tmpSize = [CommonUtil getLabelSizeByText:coinString andFont:[UIFont systemFontOfSize:20]];
    CGFloat coinImageLeftPadding = (popView.width - popCoinImageView.width - tmpSize.width - APPCONFIG_UI_VIEW_BETWEEN_PADDING) / 2.0f;
    
    [popCoinImageView bottomOfView:popTipLabel withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING];
    [popCoinImageView setMinX:coinImageLeftPadding];
    
    popCoinLabel.frame = CGRectMake(0, 0, tmpSize.width, popCoinImageView.height);
    [popCoinLabel rightOfView:popCoinImageView withMargin:APPCONFIG_UI_VIEW_BETWEEN_PADDING sameVertical:YES];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.tag = index;
    buyButton.frame = CGRectMake((popView.width - buyButtonWidth) / 2.0f, popView.height - buyButtonHeight - APPCONFIG_UI_VIEW_PADDING, buyButtonWidth, buyButtonHeight);
    buyButton.layer.cornerRadius = 15;
    buyButton.layer.masksToBounds = YES;
    [buyButton setBackgroundImage:[UIImage imageWithUIColor:themeGreyColor andCGSize:buyButton.bounds.size] forState:UIControlStateDisabled];
    [buyButton setBackgroundImage:[UIImage imageWithUIColor:themeRedColor andCGSize:buyButton.bounds.size] forState:UIControlStateNormal];
    [buyButton setTitle:@"买买买！" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(tappedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    if (coin > self.coinCount) {//我是个穷光蛋 怎能买得起 买得起
        [buyButton setEnabled:NO];
    }
    [popView addSubview:buyButton];
}

- (void)tappedCoverBackgroundButton:(UIButton *)button {
    [button removeFromSuperview];
}

- (void)tappedBuyButton:(UIButton *)button {
    NSInteger newIndex = button.tag, index;
    NSError *error;
    NSInteger coin = [StoreCoreDataHelper getCoinCountByStoreType:self.storeType andIndex:newIndex andError:&error];
    [StoreCoreDataHelper buyPartByStoreType:self.storeType andIndex:newIndex andError:&error];
    
    //计算新的硬币
    _coinCount = _coinCount - coin;
    [AccountCoreDataHelper setDataByName:@"coin" andData:[NSString stringFromInteger:_coinCount] withError:&error];
    _coinLabel.text = [NSString stringFromInteger:_coinCount];
    //选择新的按钮
    switch (self.storeType) {
        case StoreTypeHair:
            index = _hairChoice + pictureButtonTag * self.storeType;
            _hairChoice = newIndex;
            _hairImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"hair_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeEye:
            index = _eyeChoice + pictureButtonTag * self.storeType;
            _eyeChoice = newIndex;
            _eyeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"eye_tn_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeMouth:
            index = _mouthChoice + pictureButtonTag * self.storeType;
            _mouthChoice = newIndex;
            _mouthImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"mouth_tn_%@_%ld", _dict[@"gender"], (long)newIndex]];
            break;
        case StoreTypeClothes:
            index = _clothesChoice + pictureButtonTag * self.storeType;
            _clothesChoice = newIndex;
            _clothesImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"clothes_%@_%ld_%@", _dict[@"gender"], (long)newIndex, _dict[@"level"]]];
            break;
        default:
            break;
    }
    //把上一个按钮取消
    UIButton *tmpButton = (UIButton *)[_partPictScrollView viewWithTag:index];
    tmpButton.layer.borderColor = themeGreyColor.CGColor;
    //当前按钮处理
    tmpButton = (UIButton *)[_partPictScrollView viewWithTag:(newIndex + pictureButtonTag * self.storeType)];
    tmpButton.layer.borderColor = themeBlueColor.CGColor;
    for (id obj in tmpButton.subviews) {//删掉金锁
        if ([obj isMemberOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }
    
    [button.superview.superview removeFromSuperview];//移除页面
}

#pragma mark - 滚动页面委托事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //先找到上一个，去掉他
    [self changeButtonSelectStatus];
    
    NSInteger scrollPage = scrollView.contentOffset.x / scrollView.width;
    switch (scrollPage) {
        case 0:
            self.storeType = StoreTypeEye;
            break;
        case 1:
            self.storeType = StoreTypeMouth;
            break;
        case 2:
            self.storeType = StoreTypeMouth;
            break;
        case 3:
            self.storeType = StoreTypeClothes;
            break;
        default:
            break;
    }
    
    //再更新新的按钮
    [self changeButtonSelectStatus];
}

@end
