//
//  PersionInfoViewController.m
//  tt3
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PersionInfoViewController.h"
#import "XMPPvCardTemp.h"
#import "Tools.h"

@interface PersionInfoViewController ()
<UITableViewDataSource,UITableViewDelegate,
 UIImagePickerControllerDelegate>
{
    XMPPStream *xmppStream;
    XMPPvCardTempModule *vcardTempModule;
    NSMutableArray *leftViews;
    NSMutableArray *rightViews;
    NSArray *rowHeighs;
}
@end

@implementation PersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadTbaleViewDatas];
    [self tableViewSetUp];
    [self vCardSetUp];
    
}

-(void)loadTbaleViewDatas{
    leftViews = [
                 NSMutableArray arrayWithObjects:
                 @"头像",
                 @"昵称",
                 @"标签",
                 @"地址",
                 @"电话",
                 @"邮件",
                 nil
                 ];
    [leftViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        lab.text = leftViews[idx];
        lab.tag = 200 + idx;
        [leftViews replaceObjectAtIndex:idx withObject:lab];
    }];
    
    
    rightViews = [NSMutableArray array];
    for (NSInteger i = 0; i<leftViews.count; i++) {
        
        if (i==0) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 150, 3, 94, 94)];
            imgView.tag = 100 + i;
            imgView.layer.cornerRadius = 47.0f;
            imgView.clipsToBounds = YES;
            imgView.userInteractionEnabled = YES;
            imgView.image = [UIImage imageNamed:@"4"];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
            [imgView addGestureRecognizer:tap];
            
            [rightViews addObject:imgView];
        }
        else{
            UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(SCREENWIDTH - 200, 2, 170, 40)];
            textfield.tag = 100 + i;
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.layer.borderColor = [UIColor grayColor].CGColor;
            textfield.layer.borderWidth = 0.5;
            textfield.layer.cornerRadius = 5.0f;
            [rightViews addObject:textfield];
        }
    }
    
    rowHeighs = @[
                  @100,
                  @44,
                  @44,
                  @44,
                  @44,
                  @44
                  ];
}


-(void)tableViewSetUp{
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(void)vCardSetUp{

    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.vcardDelegate = self;
    [appdele setupVCard];
    xmppStream = appdele.xmppStream;
    vcardTempModule = appdele.vCardTempModule;
    [vcardTempModule  fetchvCardTempForJID:_jid ignoreStorage:YES];
}


-(void)imgTap:(UITapGestureRecognizer *)sender{
    NSInteger supportSource = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        supportSource = supportSource | 0x01;
        NSLog(@"支持相册");
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        supportSource = supportSource | 0x02;
        NSLog(@"支持相机");
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        supportSource = supportSource | 0x04;
        NSLog(@"支持图库");
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (supportSource >= 0x01) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.sourceType = type;
        picker.delegate  = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            nil;
        }];
    }
    
    
}

- (IBAction)OKBtnAction:(id)sender {
    
    NSInteger i = 1;
    for (; i<rightViews.count; i++) {
        UITextField *textTF = rightViews[i];
        if (![Tools checkVaild:textTF.text withType:NSSTRING]) {
            i = 0;
            break;
        }
    }
    
    if (i == 0) {
        [self showHudOnKeyWindowTitle:@"请输入完整数据" after:1.0];
    }
    
    [self submitPhoto];
}


-(void)submitPhoto{
    
    UIImageView *imgView = rightViews[0];
    UITextField *nickNameTF = rightViews[1];
    UITextField *labelNameTF = rightViews[2];
    UITextField *addressNameTF = rightViews[3];
    UITextField *tellNameTF = rightViews[4];
    UITextField *mailNameTF = rightViews[5];

    
    XMPPvCardTemp *vcard = [XMPPvCardTemp vCardTemp];
    vcard.nickname = nickNameTF.text;
    vcard.photo = UIImageJPEGRepresentation(imgView.image, 1.0);
    vcard.labels = @[labelNameTF.text];
    vcard.addresses = @[addressNameTF.text ];
    vcard.telecomsAddresses = @[tellNameTF.text];
    vcard.emailAddresses = @[mailNameTF.text];
    NSLog(@"send data length:%ld",vcard.photo.length);
    [vcardTempModule updateMyvCardTemp:vcard];
}

#pragma -mark UITableViewDelegate&UItabelViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return leftViews.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [rowHeighs[indexPath.row] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIView *view = [cell.contentView viewWithTag:100+indexPath.row];
    if (!view) {
        [cell.contentView addSubview:rightViews[indexPath.row]];
    }
    
    UIView *view1 = [cell.contentView viewWithTag:200+indexPath.row];
    if (!view1) {
        [cell.contentView addSubview:leftViews[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma -mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"picture info :%@",info);
    [self dismissViewControllerAnimated:picker completion:^{
    }];
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [_tableview cellForRowAtIndexPath:indexPath];
        UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:100];
        imgView.image = img;
    }
}

#pragma -mark VCardDeleage
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid{
    if (vCardTemp.photo) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];//rightViews[0];
        [self.view addSubview:imgView];
        imgView.image = [UIImage imageWithData:vCardTemp.photo];
    }
    if (vCardTemp.nickname.length>0) {
        UITextField *textF = rightViews[1];
        textF.text = vCardTemp.nickname;
    }
    NSLog(@"receive data length:%ld",vCardTemp.photo.length);

    NSLog(@"2didreceive Vcard:");
}

-(void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"1didreceive Vcard:%@",vCardTempModule.myvCardTemp.photo);
}

-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error{
    NSLog(@"3didreceive Vcard");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
