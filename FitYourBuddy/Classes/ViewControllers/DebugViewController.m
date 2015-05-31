//
//  DebugViewController.m
//  FitYourBuddy
//
//  Created by 陈文琦 on 15/4/15.
//  Copyright (c) 2015年 xpz. All rights reserved.
//

#import "DebugViewController.h"

typedef NS_ENUM(NSInteger, DebugType) {
    DebugTypeUserLevel = 0,
    DebugTypeExerciseLevel,
    DebugTypeCoin
};

@interface DebugDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) DebugType         debugType;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UITextField       *textField2;
@property (nonatomic, strong) UITextField       *textField3;
@property (nonatomic, strong) UITextField       *textField4;

@end

@implementation DebugDetailViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    NSError *error;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(tappedBackBtn)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _textField = nil, _textField2 = nil, _textField3 = nil, _textField4 = nil;
    
    switch (self.debugType) {
        case DebugTypeUserLevel: {
            self.title = @"你以为改了有用？就能人生巅峰？";
            
            _textField = [self createTextField];
            _textField.frame = CGRectMake(30, 40, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField.text = [AccountCoreDataHelper getDataByName:@"level" withError:&error];
            [self.view addSubview:_textField];
            
            _textField2 = [self createTextField];
            _textField2.frame = CGRectMake(30, 100, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField2.text = [AccountCoreDataHelper getDataByName:@"exp" withError:&error];
            [self.view addSubview:_textField2];
            
            break;
        }
        case DebugTypeExerciseLevel: {
            self.title = @"可悲，改了等级就有肌肉了？";
            
            _textField = [self createTextField];
            _textField.frame = CGRectMake(30, 40, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField.backgroundColor = sitUpColor;
            _textField.text = [AccountCoreDataHelper getDataByName:@"sitUpLevel" withError:&error];
            [self.view addSubview:_textField];
            
            _textField2 = [self createTextField];
            _textField2.frame = CGRectMake(30, 100, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField2.backgroundColor = pushUpColor;
            _textField2.text = [AccountCoreDataHelper getDataByName:@"pushUpLevel" withError:&error];
            [self.view addSubview:_textField2];
            
            _textField3 = [self createTextField];
            _textField3.frame = CGRectMake(30, 150, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField3.backgroundColor = squatColor;
            _textField3.text = [AccountCoreDataHelper getDataByName:@"squatLevel" withError:&error];
            [self.view addSubview:_textField3];
            
            _textField4 = [self createTextField];
            _textField4.frame = CGRectMake(30, 200, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField4.backgroundColor = walkColor;
            _textField4.text = [AccountCoreDataHelper getDataByName:@"walkLevel" withError:&error];
            [self.view addSubview:_textField4];
            
            break;
        }
        case DebugTypeCoin:
            self.title = @"改吧改吧，再改也是穷逼！";
            
            _textField = [self createTextField];
            _textField.frame = CGRectMake(30, 40, APPCONFIG_UI_SCREEN_FWIDTH - 60, 40);
            _textField.text = [AccountCoreDataHelper getDataByName:@"coin" withError:&error];
            [self.view addSubview:_textField];
            break;
        default:
            break;
    }
}

- (UITextField *)createTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = transparentBlackColor;
    textField.textColor = [UIColor whiteColor];
    textField.tintColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.delegate = self;
    
    return textField;
}

#pragma mark - 点击事件
- (void)tappedBackBtn {
    NSError *error;
    switch (_debugType) {
        case DebugTypeUserLevel: {
            if (!_textField.text.isPureInt || !_textField2.text.isPureInt) {
                [self popAlertView];
                return;
            }
            [AccountCoreDataHelper setDataByName:@"level" andData:_textField.text withError:&error];
            [AccountCoreDataHelper setDataByName:@"exp" andData:_textField2.text withError:&error];
            
            break;
        }
            
        case DebugTypeExerciseLevel: {
            if (!_textField.text.isPureInt || !_textField2.text.isPureInt || !_textField3.text.isPureInt || !_textField4.text.isPureInt) {
                [self popAlertView];
                return;
            }
            [AccountCoreDataHelper setDataByName:@"sitUpLevel" andData:_textField.text withError:&error];
            [AccountCoreDataHelper setDataByName:@"pushUpLevel" andData:_textField2.text withError:&error];
            [AccountCoreDataHelper setDataByName:@"squatLevel" andData:_textField3.text withError:&error];
            [AccountCoreDataHelper setDataByName:@"walkLevel" andData:_textField4.text withError:&error];
            
            break;
        }
            
        case DebugTypeCoin: {
            if (!_textField.text.isPureInt) {
                [self popAlertView];
                return;
            }
            [AccountCoreDataHelper setDataByName:@"coin" andData:_textField.text withError:&error];
            break;
        }
        default:
            break;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"哥，能不能别闹" message:@"别寻开心！程序崩溃了你负责吗？" delegate:nil cancelButtonTitle:@"快点我，然后老老实实输数字" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Text Field Delegate
//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end

@interface DebugViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView    *myTableView;
@property(nonatomic, strong) NSArray        *myArray;

@end

@implementation DebugViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* backButon = [UIButton buttonWithType:UIButtonTypeCustom];
    backButon.frame = CGRectMake(0, 0, APPCONFIG_UI_VIEW_FWIDTH, APPCONFIG_UI_NAVIGATIONBAR_HEIGHT + APPCONFIG_UI_STATUSBAR_HEIGHT);
    [backButon setTitle:@"Welcome To The Sin World" forState:UIControlStateNormal];
    [backButon addTarget:self action:@selector(tappedBackButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = backButon;
    
    _myArray = @[@"你..你要对人物等级干什么", @"明明只是锻炼等级而已，少得意了", @"金币什么的我才不要呢，哼"];
    
    UITableView *tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    _myTableView = tabelView;
    [self.view addSubview:tabelView];
    
    [tabelView reloadData];
}

#pragma mark - 点击事件
- (void)tappedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_myTableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"tabelCellID"]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tabelCellID"];
    }
    
    cell.textLabel.text = _myArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DebugDetailViewController *ddvc = [[DebugDetailViewController alloc] init];
    ddvc.debugType = indexPath.row;
    [self.navigationController pushViewController:ddvc animated:YES];
}

@end
