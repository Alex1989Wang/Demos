//
//  AGDLoginViewController.m
//  AgoraDemo
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 Agora. All rights reserved.
//

#import "AGDLoginViewController.h"
#import "AGDChatViewController.h"

static NSString * const AGDSegueIdentifierChat = @"Chat";

@interface AGDLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomNumberTextField;

@end

@implementation AGDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *vendorKey = [userDefaults objectForKey:AGDKeyVendorKey];
    if (vendorKey) {
        self.keyTextField.text = vendorKey;
    } else {
        NSError *error = nil;
        NSURL *innerKeyUrl = [NSURL URLWithString:@"http://192.168.99.253:8970/agora.inner.test.key.txt"];
        NSString *innerVendorKey = [NSString stringWithContentsOfURL:innerKeyUrl
                                                     encoding:NSASCIIStringEncoding
                                                        error: &error];

        if (!error) {
            if (!innerVendorKey) {
                self.keyTextField.text = [innerVendorKey
                                  stringByReplacingOccurrencesOfString:@"\n" withString:@""];; // Please use your own key. The inner test key is just invalid in public.
            }

        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.identifier isEqualToString:AGDSegueIdentifierChat]) {return;}
    
    AGDChatViewController *chatViewController = segue.destinationViewController;
    chatViewController.dictionary = @{AGDKeyChannel: self.roomNumberTextField.text,
                                      AGDKeyVendorKey: self.keyTextField.text};
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        chatViewController.chatType = AGDChatTypeVideo;
    } else {
        chatViewController.chatType = AGDChatTypeAudio;
    }
}

#pragma mark -

- (IBAction)didClickPushChatViewController:(id)sender
{
    
    if ([self isValidInput]) {
        [self performSegueWithIdentifier:AGDSegueIdentifierChat sender:sender];
    }
}

- (BOOL)isValidInput
{
    [self.view endEditing:YES];
    if (_keyTextField.text.length && _roomNumberTextField.text.length) {
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"enter_key_room", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"done", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}

- (IBAction)didTapHideKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
