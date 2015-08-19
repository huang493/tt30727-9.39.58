//
//  PersionInfoViewController.m
//  tt3
//
//  Created by apple on 15/8/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PersionInfoViewController.h"


@interface PersionInfoViewController ()
{
    XMPPStream *xmppStream;
    XMPPvCardTempModule *vcardTempModule;
}
@end

@implementation PersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    AppDelegate *appdele = [UIApplication sharedApplication].delegate;
    appdele.vcardDelegate = self;
    [appdele setupVCard];
    xmppStream = appdele.xmppStream;
    vcardTempModule = appdele.vCardTempModule;
    [vcardTempModule  fetchvCardTempForJID:_jid ignoreStorage:YES];
}

-(void)setVcardDelegate{

}

-(void)getMyVcard{
    
}

-(XMPPStream*)getXmpp{
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    return appDel.xmppStream;
}
-(XMPPvCardTempModule *)getVcardTempModule{
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    return appDel.vCardTempModule;
}

- (IBAction)OKBtnAction:(id)sender {
    
    [self submitPhoto];
}


-(void)submitPhoto{
    
}










#pragma -mark VCardDeleage
-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid{
    NSLog(@"%s",__FUNCTION__);
}

-(void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"%s",__FUNCTION__);

}

-(void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(DDXMLElement *)error{
    NSLog(@"%s",__FUNCTION__);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
