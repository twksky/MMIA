//
//  ViewController.m
//  QQApiInterfaceDemo
//
//  Created by Random Zhang on 12-5-16.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "QQApiDemoController.h"
#import "TCApiObjectEditController.h"
#import "TCQRCodeGenerator.h"
#import "TencentRequest.h"

#define TCSafeRelease(__tcObj) { [__tcObj release]; __tcObj = nil; }

#define kTenpayID @"kTenpayID"

@interface QQApiDemoController () <TencentRequestDelegate>

@property (nonatomic, strong) UITableView *operationTable;
@property (nonatomic, strong) NSArray *operationList;

@property (nonatomic, strong) NSString *tenpayID;
@property (nonatomic, strong) TencentRequest *requestQRStr;
@property (nonatomic, strong) UIControl *qrcodePanel;
@property (nonatomic, strong) UIImageView *qrcodeImgView;

- (void)showQRCode:(NSString *)qrcode;
- (void)onQRCodePanelClick:(id)sender;

#if BUILD_QQAPIDEMO
- (void)handleSendResult:(QQApiSendResultCode)sendResult;
#endif

@end

@implementation QQApiDemoController

@synthesize operationTable = _operationTable;
@synthesize operationList = _operationList;

@synthesize requestQRStr = _requestQRStr;

-(void)dealloc
{
    self.requestQRStr.delegate = nil;
    [self.requestQRStr cancel];
    self.requestQRStr = nil;
    
    self.operationTable = nil;
    self.operationList = nil;
    self.qrcodePanel = nil;
    self.qrcodeImgView = nil;
    self.tenpayID = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = [[self view] bounds];

    self.operationList = [NSArray arrayWithObjects:
                          @"发送文本消息",
                          @"发送图片消息",
                          @"发送新闻消息(本地图片)",
                          @"发送音频消息",
                          @"发送视频消息",
                          @"生成订单号",
                          @"手Q支付",
                          @"发送新闻消息(网络图片)",
                          nil];
    
    self.operationTable = [[[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped] autorelease];
    self.operationTable.backgroundColor = [UIColor colorWithRed:(214.f/255.f) green:(214.f/255.f) blue:(214.f/255.f) alpha:1];
    self.operationTable.scrollEnabled = YES;
    self.operationTable.dataSource = self;
    self.operationTable.delegate = self;
    [self.view addSubview:self.operationTable];
    
    self.qrcodePanel = [[[UIControl alloc] initWithFrame:frame] autorelease];
    self.qrcodePanel.hidden = YES;
    self.qrcodePanel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.qrcodePanel addTarget:self action:@selector(onQRCodePanelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.qrcodePanel];
    
    CGRect panelFrame = [self.qrcodePanel bounds];
    CGFloat minSize = MIN(panelFrame.size.width, panelFrame.size.height) * 0.9f;
    self.qrcodeImgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minSize, minSize)] autorelease];
    self.qrcodeImgView.center = CGPointMake(CGRectGetMidX(panelFrame), CGRectGetMidY(panelFrame));
    [self.qrcodePanel addSubview:self.qrcodeImgView];
    
    self.tenpayID = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.operationTable = nil;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

// Override to allow orientations other than the default portrait orientation ios6.0
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.operationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [self.operationTable dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.operationList objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
	int row = indexPath.row;
	if(section == 0)
    {
		switch (row)
        {
			case 0:
				// QQ login
				[self sendTextMessage];
				break;
			case 1:
				[self sendImageMessage];
				break;                
			case 2:
				[self sendNewsMessageWithLocalImage];
				break;
			case 3:
				[self sendAudioMessage];
				break;
			case 4:
				[self sendVideoMessage];
				break;
            case 5:
                [self CreatePayID];
				break;
            case 6:
				[self PayFromIphoneQQ];
				break;
            case 7:
                [self sendNewsMessageWithNetworkImage];
                break;
			default:
				NSLog(@"No event handling for row %d",row);
				break;
		}
	}
	
	[_operationTable deselectRowAtIndexPath:indexPath animated:YES];
}

#if BUILD_QQAPIDEMO
- (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif

#if BUILD_QQAPIDEMO
- (void)onResp:(QQBaseResp *)resp
{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif

- (void) sendTextMessage
{
#if BUILD_QQAPIDEMO
    
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objTitle.hidden = YES;
    apiObjEditCtrl.objDesc.hidden = YES;
    apiObjEditCtrl.objUrl.hidden = YES;
    apiObjEditCtrl.objText.text = @"马化腾指出，过去两年移动互联网有很多开放平台非常成功。事实上到现在来看，发展到现在一年多，最关键的开放平台是能不能真正从用户和经济回报中打造生态链。";

    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
        {
            QQApiTextObject* txtObj = [QQApiTextObject objectWithText:editCtrl.objText.text];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
            
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
        cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)
    
#endif
}

- (void) sendImageMessage
{
#if BUILD_QQAPIDEMO
    
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objText.hidden = YES;
    apiObjEditCtrl.objUrl.hidden = YES;
    apiObjEditCtrl.objTitle.text = @"test title";
    apiObjEditCtrl.objDesc.text = @"desc";
    
    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
        {
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img.jpg"];
            NSData* data = [NSData dataWithContentsOfFile:path];

            QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:data title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];

            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
              cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)
    
#endif
}

- (void) sendNewsMessageWithLocalImage
{
#if BUILD_QQAPIDEMO
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objText.hidden = YES;
    apiObjEditCtrl.objTitle.text = @"天公作美伦敦奥运圣火点燃成功 火炬传递开启";
    apiObjEditCtrl.objDesc.text = @"腾讯体育讯 当地时间5月10日中午，阳光和全世界的目光聚焦于希腊最高女祭司手中的火炬上，5秒钟内世界屏住呼吸。火焰骤然升腾的瞬间，古老的号角声随之从赫拉神庙传出——第30届伦敦夏季奥运会圣火在古奥林匹亚遗址点燃。取火仪式前，国际奥委会主席罗格、希腊奥委会主席卡普拉洛斯和伦敦奥组委主席塞巴斯蒂安-科互赠礼物，男祭司继北京奥运会后，再度出现在采火仪式中。";
    apiObjEditCtrl.objUrl.text = @"http://www.163.com";
    
    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
     {
         NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
         NSData* data = [NSData dataWithContentsOfFile:path];
         NSURL* url = [NSURL URLWithString:apiObjEditCtrl.objUrl.text];
         
         QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text previewImageData:data];
         SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
         
         QQApiSendResultCode sent = [QQApiInterface sendReq:req];
         [self handleSendResult:sent];
     }
              cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)

#endif
}

- (void) sendAudioMessage
{
#if BUILD_QQAPIDEMO
    
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objText.hidden = YES;
    apiObjEditCtrl.objTitle.text = @"Wish You Were Here";
    apiObjEditCtrl.objDesc.text = @"Avril Lavigne";
    apiObjEditCtrl.objUrl.text = @"http://wfmusic.3g.qq.com/s?g_f=0&fr=&aid=mu_detail&id=2511915";
    
    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
        {
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"audio.jpg"];
            NSData* data = [NSData dataWithContentsOfFile:path];
            NSURL* url = [NSURL URLWithString:apiObjEditCtrl.objUrl.text];

            QQApiAudioObject* img = [QQApiAudioObject objectWithURL:url title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text previewImageData:data];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];

            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
              cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)
    
#endif
}

- (void) sendVideoMessage
{
#if BUILD_QQAPIDEMO
    
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objText.hidden = YES;
    apiObjEditCtrl.objTitle.text = @"腾讯暗黑风动作新游《天刹》国服视频曝光";
    apiObjEditCtrl.objDesc.text = @"你觉得正在玩的动作游戏的打击感不够好？战斗不够真实缺乏技巧？PVP索然无味完全是比谁装备好？那么现在有款新游戏或许能满足你的胃口！ 《天刹》是由韩国nse公司开发，腾讯全球代理中国首发的3D锁视角动作游戏，是一款有着暗黑写实风格、东方奇幻题材的游戏，具备打击感十足的动作体验、策略多变的战斗方式，游戏操作不难但有足够的深度，在动作游戏领域首次引入了手动格挡格斗机制，构建快速攻防转换体系。 官方网站：tian.qq.com 官方微博：http://t.qq.com/tiancha001";
    apiObjEditCtrl.objUrl.text = @"http://www.tudou.com/programs/view/_cVM3aAp270/";
    
    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
        {
            NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"video.jpg"];
            NSData* data = [NSData dataWithContentsOfFile:path];
            NSURL* url = [NSURL URLWithString:apiObjEditCtrl.objUrl.text];

            QQApiVideoObject* img = [QQApiVideoObject objectWithURL:url title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text previewImageData:data];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];

            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleSendResult:sent];
        }
              cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)
    
#endif
}

- (NSInteger)GetRandomNumber:(NSInteger)start to:(NSInteger)end
{
    return (NSInteger)(start + (arc4random() % (end - start + 1)));
}

- (void)CreatePayID
{
    #if BUILD_QQAPIDEMO
    if (self.requestQRStr)
    {
        self.requestQRStr.delegate = nil;
        [self.requestQRStr cancel];
        self.requestQRStr = nil;
    }
    
    NSNumber *Billno_Tail = [NSNumber numberWithInteger:[self GetRandomNumber:0 to:9999]];
    
    NSString *Param = [NSString stringWithFormat:@"attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=19000001094949%@&total_fee=1&ver=2.0", [Billno_Tail stringValue]];
    
    NSString *ParamMD5 = [NSString stringWithFormat:@"%@&key=8934e7d15453e97507ef794cf7b0519d", Param];
    
    NSString *url = [NSString stringWithFormat:@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?%@&sign=%@", Param, [[ParamMD5 md5Hash] uppercaseString]];
    
    NSString *PayIDInfo = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    //@"https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_init.cgi?attach=test&bank_type=0&bargainor_id=1900000109&callback_url=http://abc&charset=1&desc=test&fee_type=1&notify_url=http://abc&purchaser_id=583873140&sp_billno=190000010949497578&total_fee=1&ver=2.0&sign=2CC44AB13B9FD4131240FCC74AD8E988"] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%s|PayIDInfo:\n%@", __FUNCTION__, PayIDInfo);
    
    NSString *PayID = nil;
    NSRange start = [PayIDInfo rangeOfString:@"<token_id>"];
    if (NSNotFound != start.location)
    {
        PayID = [PayIDInfo substringFromIndex:start.location + start.length];
        NSRange end = [PayID rangeOfString:@"</token_id>"];
        if (NSNotFound != end.location)
        {
            PayID = [PayID substringToIndex:end.location];
        }
        else
        {
            PayID = nil;
        }
    }
    
    NSLog(@"%s|PayID:\n%@", __FUNCTION__, PayID);
// https://graph.qq.com/vendor/open_qr?d=1234567&sign=3bf68cf5669f2a51a65189dc3c13831f&appid=100442986
//    APP ID：100442986
//    APP KEY：40836535e61977a2da874ba3ad09607c
    if (PayID)
    {
        self.tenpayID = PayID;
        NSString *appKey = @"40836535e61977a2da874ba3ad09607c";
        NSString *d = PayID;
        NSString *sign = [[NSString stringWithFormat:@"d=%@&type=%@%@", [d urlEncoded], [@"4" urlEncoded], appKey] md5Hash];
        NSString *appId = @"100442986";
        
        NSMutableDictionary *reqParams = [NSMutableDictionary dictionaryWithDictionary:@{
                                          @"type": @"4",
                                          @"d": d,
                                          @"sign": sign,
                                          @"appid": appId}];
        self.requestQRStr = [TencentRequest getRequestWithParams:reqParams httpMethod:@"POST" delegate:self requestURL:@"https://graph.qq.com/vendor/open_qr"];
        [self.requestQRStr connect];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"PayID获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        [msgbox release];
    }
    #endif
}

- (void)PayFromIphoneQQ
{
#if BUILD_QQAPIDEMO
    QQApiPayObject *payObj = [QQApiPayObject objectWithOrderNo:self.tenpayID];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:payObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
#endif
}

- (void) sendNewsMessageWithNetworkImage
{
#if BUILD_QQAPIDEMO
    
    TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
    apiObjEditCtrl.objText.hidden = YES;
    apiObjEditCtrl.objTitle.text = @"天公作美伦敦奥运圣火点燃成功 火炬传递开启";
    apiObjEditCtrl.objDesc.text = @"腾讯体育讯 当地时间5月10日中午，阳光和全世界的目光聚焦于希腊最高女祭司手中的火炬上，5秒钟内世界屏住呼吸。火焰骤然升腾的瞬间，古老的号角声随之从赫拉神庙传出——第30届伦敦夏季奥运会圣火在古奥林匹亚遗址点燃。取火仪式前，国际奥委会主席罗格、希腊奥委会主席卡普拉洛斯和伦敦奥组委主席塞巴斯蒂安-科互赠礼物，男祭司继北京奥运会后，再度出现在采火仪式中。";
    apiObjEditCtrl.objUrl.text = @"http://www.163.com";
    
    [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
     {
         NSURL *previewURL = [NSURL URLWithString:@"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg"];
         NSURL* url = [NSURL URLWithString:apiObjEditCtrl.objUrl.text];
         
         QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text previewImageURL:previewURL];
         SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
         
         QQApiSendResultCode sent = [QQApiInterface sendReq:req];
         [self handleSendResult:sent];
     }
              cancelHandler:NULL animated:YES];
    TCSafeRelease(apiObjEditCtrl)
#endif
}

#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#if BUILD_QQAPIDEMO
    if (nil != picker)
    {
        NSURL *picUrl = (NSURL *)[info objectForKey:UIImagePickerControllerReferenceURL];
        [self dismissModalViewControllerAnimated:NO];
        
        TCApiObjectEditController *apiObjEditCtrl = [[TCApiObjectEditController alloc] initWithNibName:nil bundle:nil];
        apiObjEditCtrl.objText.hidden = YES;
        apiObjEditCtrl.objTitle.text = @"天公作美伦敦奥运圣火点燃成功 火炬传递开启";
        apiObjEditCtrl.objDesc.text = @"腾讯体育讯 当地时间5月10日中午，阳光和全世界的目光聚焦于希腊最高女祭司手中的火炬上，5秒钟内世界屏住呼吸。火焰骤然升腾的瞬间，古老的号角声随之从赫拉神庙传出——第30届伦敦夏季奥运会圣火在古奥林匹亚遗址点燃。取火仪式前，国际奥委会主席罗格、希腊奥委会主席卡普拉洛斯和伦敦奥组委主席塞巴斯蒂安-科互赠礼物，男祭司继北京奥运会后，再度出现在采火仪式中。";
        apiObjEditCtrl.objUrl.text = @"http://www.163.com";
        
        [apiObjEditCtrl modalIn:self withDoneHandler:^(TCApiObjectEditController *editCtrl)
         {
             NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.jpg"];
             //NSData* data = [NSData dataWithContentsOfFile:path];
             NSURL* url = [NSURL URLWithString:apiObjEditCtrl.objUrl.text];
             
             QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:apiObjEditCtrl.objTitle.text description:apiObjEditCtrl.objDesc.text previewImageURL:picUrl];
             SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
             
             QQApiSendResultCode sent = [QQApiInterface sendReq:req];
             [self handleSendResult:sent];
         }
                  cancelHandler:NULL animated:YES];
        TCSafeRelease(apiObjEditCtrl)

    }
    
   #endif
}


#if BUILD_QQAPIDEMO
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}
#endif

- (void)showQRCode:(NSString *)qrcode
{
    CGFloat size = self.qrcodeImgView.bounds.size.width;
    UIImage *qrcodeImg = [TCQRCodeGenerator qrImageForString:qrcode imageSize:size];
    
    [self.qrcodeImgView setImage:qrcodeImg];
    [self.qrcodePanel setHidden:NO];
}

- (void)onQRCodePanelClick:(id)sender
{
    if (sender == self.qrcodePanel)
    {
        [sender setHidden:YES];
    }
}

#pragma mark -
#pragma mark TencentRequestDelegate
- (void)request:(TencentRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR获取失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [msgbox show];
    [msgbox release];
}

- (void)request:(TencentRequest *)request didLoad:(id)result dat:(NSData *)data
{
    NSString *tenpayUrl = [result objectForKey:@"url"];
    if (tenpayUrl)
    {
        [self showQRCode:tenpayUrl];
    }
    else
    {
        UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"TenpayQR解析失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
        [msgbox release];
    }
}

@end
