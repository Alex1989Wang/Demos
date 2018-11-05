//
//  ZTCrashAssignPropertyViewController.m
//  ZombieTest
//
//  Created by JiangWang on 2018/11/5.
//  Copyright © 2018 JiangWang. All rights reserved.
//

#import "ZTCrashAssignPropertyViewController.h"
#import "ZTDummyObject.h"

@interface ZTCrashAssignPropertyViewController ()
@property (nonatomic, assign) ZTDummyObject *dummy;
@end

@implementation ZTCrashAssignPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dummy = [[ZTDummyObject alloc] init];
}

- (IBAction)clickToCrash:(UIButton *)sender {
    [self.dummy dummyMethod];
}

/*
 Incident Identifier: 69B321F6-55D3-40C5-85DE-CD33915AD66F
 CrashReporter Key:   909fdd5cffda1aeb51a4ca164411cd95c5424e80
 Hardware Model:      iPhone9,1
 Process:             ZombieTest [2094]
 Path:                /private/var/containers/Bundle/Application/9F6FA259-9B67-4A9A-9281-86176CE21923/ZombieTest.app/ZombieTest
 Identifier:          com.jiangwang.ZombieTest
 Version:             1 (1.0)
 Code Type:           ARM-64 (Native)
 Role:                Foreground
 Parent Process:      launchd [1]
 Coalition:           com.jiangwang.ZombieTest [685]
 
 
 Date/Time:           2018-11-05 14:55:25.3494 +0800
 Launch Time:         2018-11-05 14:55:23.4122 +0800
 OS Version:          iPhone OS 11.2.6 (15D100)
 Baseband Version:    3.42.00
 Report Version:      104
 
 Exception Type:  EXC_CRASH (SIGABRT)
 Exception Codes: 0x0000000000000000, 0x0000000000000000
 Exception Note:  EXC_CORPSE_NOTIFY
 Triggered by Thread:  0
 
 Application Specific Information:
 abort() called
 
 Filtered syslog:
 None found
 
 Last Exception Backtrace:
 0   CoreFoundation                    0x186433164 __exceptionPreprocess + 124
 1   libobjc.A.dylib                   0x18567c528 objc_exception_throw + 55
 2   CoreFoundation                    0x186440628 -[NSObject+ 1377832 (NSObject) doesNotRecognizeSelector:] + 139
 3   CoreFoundation                    0x186438b10 ___forwarding___ + 1379
 4   CoreFoundation                    0x18631dccc _CF_forwarding_prep_0 + 91
 5   ZombieTest                        0x104651bc0 0x10464c000 + 23488
 6   UIKit                             0x18fa225cc -[UIApplication sendAction:to:from:forEvent:] + 95
 7   UIKit                             0x18fa2254c -[UIControl sendAction:to:forEvent:] + 79
 8   UIKit                             0x18fa0d0f4 -[UIControl _sendActionsForEvents:withEvent:] + 439
 9   UIKit                             0x18fa21e40 -[UIControl touchesEnded:withEvent:] + 575
 10  UIKit                             0x18fa21960 -[UIWindow _sendTouchesForEvent:] + 2543
 11  UIKit                             0x18fa1ce78 -[UIWindow sendEvent:] + 3207
 12  UIKit                             0x18f9ede7c -[UIApplication sendEvent:] + 339
 13  UIKit                             0x19034330c __dispatchPreprocessedEventFromEventQueue + 2363
 14  UIKit                             0x190345898 __handleEventQueueInternal + 4759
 15  UIKit                             0x19033e7b0 __handleHIDEventFetcherDrain + 151
 16  CoreFoundation                    0x1863db77c __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 23
 17  CoreFoundation                    0x1863db6fc __CFRunLoopDoSource0 + 87
 18  CoreFoundation                    0x1863daf84 __CFRunLoopDoSources0 + 203
 19  CoreFoundation                    0x1863d8b5c __CFRunLoopRun + 1047
 20  CoreFoundation                    0x1862f8c58 CFRunLoopRunSpecific + 435
 21  GraphicsServices                  0x1881a4f84 GSEventRunModal + 99
 22  UIKit                             0x18fa515c4 UIApplicationMain + 235
 23  ZombieTest                        0x104651cf0 0x10464c000 + 23792
 24  libdyld.dylib                     0x185e1856c start + 3
 
 
 Thread 0 name:  Dispatch queue: com.apple.main-thread
 Thread 0 Crashed:
 0   libsystem_kernel.dylib            0x0000000185f482e8 __pthread_kill + 8
 1   libsystem_pthread.dylib           0x000000018605d2f8 pthread_kill$VARIANT$mp + 396
 2   libsystem_c.dylib                 0x0000000185eb6fbc abort + 140
 3   libc++abi.dylib                   0x0000000185654068 __cxa_bad_cast + 0
 4   libc++abi.dylib                   0x0000000185654210 default_unexpected_handler+ 8720 () + 0
 5   libobjc.A.dylib                   0x000000018567c810 _objc_terminate+ 34832 () + 124
 6   libc++abi.dylib                   0x000000018566c54c std::__terminate(void (*)+ 107852 ()) + 16
 7   libc++abi.dylib                   0x000000018566c158 __cxa_rethrow + 144
 8   libobjc.A.dylib                   0x000000018567c6e8 objc_exception_rethrow + 44
 9   CoreFoundation                    0x00000001862f8cc4 CFRunLoopRunSpecific + 544
 10  GraphicsServices                  0x00000001881a4f84 GSEventRunModal + 100
 11  UIKit                             0x000000018fa515c4 UIApplicationMain + 236
 12  ZombieTest                        0x0000000104651cf0 0x10464c000 + 23792
 13  libdyld.dylib                     0x0000000185e1856c start + 4
 
 Thread 1:
 0   libsystem_kernel.dylib            0x0000000185f48d80 __workq_kernreturn + 8
 1   libsystem_pthread.dylib           0x000000018605aeec _pthread_wqthread + 884
 2   libsystem_pthread.dylib           0x000000018605ab6c start_wqthread + 4
 
 Thread 2:
 0   libsystem_pthread.dylib           0x000000018605ab68 start_wqthread + 0
 
 Thread 3:
 0   libsystem_pthread.dylib           0x000000018605ab68 start_wqthread + 0
 
 Thread 4:
 0   libsystem_pthread.dylib           0x000000018605ab68 start_wqthread + 0
 
 Thread 5:
 0   libsystem_pthread.dylib           0x000000018605ab68 start_wqthread + 0
 
 Thread 6 name:  com.apple.uikit.eventfetch-thread
 Thread 6:
 0   libsystem_kernel.dylib            0x0000000185f27568 mach_msg_trap + 8
 1   libsystem_kernel.dylib            0x0000000185f273e0 mach_msg + 72
 2   CoreFoundation                    0x00000001863db108 __CFRunLoopServiceMachPort + 196
 3   CoreFoundation                    0x00000001863d8cd4 __CFRunLoopRun + 1424
 4   CoreFoundation                    0x00000001862f8c58 CFRunLoopRunSpecific + 436
 5   Foundation                        0x0000000186d2d594 -[NSRunLoop+ 50580 (NSRunLoop) runMode:beforeDate:] + 304
 6   Foundation                        0x0000000186d4c9ac -[NSRunLoop+ 178604 (NSRunLoop) runUntilDate:] + 96
 7   UIKit                             0x00000001905bb7a8 -[UIEventFetcher threadMain] + 136
 8   Foundation                        0x0000000186e2f0f4 __NSThread__start__ + 996
 9   libsystem_pthread.dylib           0x000000018605c2b4 _pthread_body + 308
 10  libsystem_pthread.dylib           0x000000018605c180 _pthread_body + 0
 11  libsystem_pthread.dylib           0x000000018605ab74 thread_start + 4
 
 Thread 0 crashed with ARM Thread State (64-bit):
 x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x00000001c00fe437
 x4: 0x0000000185671afd   x5: 0x000000016b7b34c0   x6: 0x000000000000006e   x7: 0xffffffffffffffec
 x8: 0x0000000008000000   x9: 0x0000000004000000  x10: 0x00000001860615e0  x11: 0x0000000000000003
 x12: 0xffffffffffffffff  x13: 0x0000000000000001  x14: 0x0000000185ecd53f  x15: 0x0000000000000010
 x16: 0x0000000000000148  x17: 0x00000000ffffffff  x18: 0xfffffff0214dd260  x19: 0x0000000000000006
 x20: 0x00000001b77a1b80  x21: 0x000000016b7b34c0  x22: 0x0000000000000303  x23: 0x00000001b77a1c60
 x24: 0x00000001c400e620  x25: 0x0000000000000000  x26: 0x0000000000000001  x27: 0x0000000000000000
 x28: 0x000000016b7b3b30   fp: 0x000000016b7b3420   lr: 0x000000018605d2f8
 sp: 0x000000016b7b33f0   pc: 0x0000000185f482e8 cpsr: 0x00000000
 
 Binary Images:
 0x10464c000 - 0x104653fff ZombieTest arm64  <f56212782da3353aba9d39333e745dc7> /var/containers/Bundle/Application/9F6FA259-9B67-4A9A-9281-86176CE21923/ZombieTest.app/ZombieTest
 0x1047e4000 - 0x104823fff dyld arm64  <477a8a1f098b3a80860d656a3f4918ea> /usr/lib/dyld
 0x1855f6000 - 0x1855f7fff libSystem.B.dylib arm64  <a9f67ca8b7963c699078236267472fb0> /usr/lib/libSystem.B.dylib
 0x1855f8000 - 0x185651fff libc++.1.dylib arm64  <aee157a049663aa88c4e928768cfd553> /usr/lib/libc++.1.dylib
 0x185652000 - 0x185672fff libc++abi.dylib arm64  <b4f54419327f3bfea747549b84dad328> /usr/lib/libc++abi.dylib
 0x185674000 - 0x185d2ffff libobjc.A.dylib arm64  <3a9d464322eb3285bc88fabf7cec20ed> /usr/lib/libobjc.A.dylib
 0x185d30000 - 0x185d34fff libcache.dylib arm64  <474a695498903419b648b834067fac4e> /usr/lib/system/libcache.dylib
 0x185d35000 - 0x185d40fff libcommonCrypto.dylib arm64  <f3a95fbdb7a037879160ae9e0ee14c37> /usr/lib/system/libcommonCrypto.dylib
 0x185d41000 - 0x185d44fff libcompiler_rt.dylib arm64  <502de73c3e0c3ba78280e6164fe5728c> /usr/lib/system/libcompiler_rt.dylib
 0x185d45000 - 0x185d4cfff libcopyfile.dylib arm64  <b8c962560a1b3b639d562541d32f5960> /usr/lib/system/libcopyfile.dylib
 0x185d4d000 - 0x185db0fff libcorecrypto.dylib arm64  <db41a416fa083812bcafad6b888b152e> /usr/lib/system/libcorecrypto.dylib
 0x185db1000 - 0x185e16fff libdispatch.dylib arm64  <37135142d2043b5492d7a49be678b9ae> /usr/lib/system/libdispatch.dylib
 0x185e17000 - 0x185e31fff libdyld.dylib arm64  <4f57dfca63a93930a57d2cea89307b01> /usr/lib/system/libdyld.dylib
 0x185e32000 - 0x185e32fff liblaunch.dylib arm64  <ca90373a022d3c38ac7ecd736c13bf9b> /usr/lib/system/liblaunch.dylib
 0x185e33000 - 0x185e38fff libmacho.dylib arm64  <25640409947b3e20b1135068c80d8609> /usr/lib/system/libmacho.dylib
 0x185e39000 - 0x185e3afff libremovefile.dylib arm64  <848fca02e8d930fd8659eb188d9bcedd> /usr/lib/system/libremovefile.dylib
 0x185e3b000 - 0x185e52fff libsystem_asl.dylib arm64  <255a36a954553a278ef2c8711ab62532> /usr/lib/system/libsystem_asl.dylib
 0x185e53000 - 0x185e53fff libsystem_blocks.dylib arm64  <cbdfd75e23c43610991dc81d325587ea> /usr/lib/system/libsystem_blocks.dylib
 0x185e54000 - 0x185ed1fff libsystem_c.dylib arm64  <2c43d27314963feb8966491ea64cf5a9> /usr/lib/system/libsystem_c.dylib
 0x185ed2000 - 0x185ed6fff libsystem_configuration.dylib arm64  <897ce699a6d73797810d7fe5ceef37d7> /usr/lib/system/libsystem_configuration.dylib
 0x185ed7000 - 0x185edcfff libsystem_containermanager.dylib arm64  <ae270ac5b9613cfcb5a6ada4520b8a8b> /usr/lib/system/libsystem_containermanager.dylib
 0x185edd000 - 0x185edefff libsystem_coreservices.dylib arm64  <c897206125f13042a7f62767de020ae9> /usr/lib/system/libsystem_coreservices.dylib
 0x185edf000 - 0x185ee0fff libsystem_darwin.dylib arm64  <fc17590f3b6f3e2280aa164fe705e624> /usr/lib/system/libsystem_darwin.dylib
 0x185ee1000 - 0x185ee7fff libsystem_dnssd.dylib arm64  <2fdef17227d13f49929b104ec635667c> /usr/lib/system/libsystem_dnssd.dylib
 0x185ee8000 - 0x185f25fff libsystem_info.dylib arm64  <c20c44a2d57b330f9931ba840195ee45> /usr/lib/system/libsystem_info.dylib
 0x185f26000 - 0x185f4efff libsystem_kernel.dylib arm64  <6ca465bb9c013f9ab3fb24dd16418142> /usr/lib/system/libsystem_kernel.dylib
 0x185f4f000 - 0x185f7cfff libsystem_m.dylib arm64  <a75c726ec49b3f48b83593be165afcfa> /usr/lib/system/libsystem_m.dylib
 0x185f7d000 - 0x185f97fff libsystem_malloc.dylib arm64  <cce71425b3483c5fa3718246e8e27ed2> /usr/lib/system/libsystem_malloc.dylib
 0x185f98000 - 0x186038fff libsystem_network.dylib arm64  <cac262c32d6938abb9075481187087c4> /usr/lib/system/libsystem_network.dylib
 0x186039000 - 0x186044fff libsystem_networkextension.dylib arm64  <40f740c2ec9b37cebe6043eecbd1927d> /usr/lib/system/libsystem_networkextension.dylib
 0x186045000 - 0x18604ffff libsystem_notify.dylib arm64  <c204b6b2ef2d38669fb985bc64f26a6b> /usr/lib/system/libsystem_notify.dylib
 0x186050000 - 0x186059fff libsystem_platform.dylib arm64  <1fd32dd6f1da3029ae0fe5875eaceb94> /usr/lib/system/libsystem_platform.dylib
 0x18605a000 - 0x186069fff libsystem_pthread.dylib arm64  <2f9b440f88eb3cedb786b4b98586d78f> /usr/lib/system/libsystem_pthread.dylib
 0x18606a000 - 0x18606dfff libsystem_sandbox.dylib arm64  <001e1a85480c3b07b93861fe7e69843b> /usr/lib/system/libsystem_sandbox.dylib
 0x18606e000 - 0x186075fff libsystem_symptoms.dylib arm64  <56e7c311193139968b729073897fbdc6> /usr/lib/system/libsystem_symptoms.dylib
 0x186076000 - 0x186089fff libsystem_trace.dylib arm64  <8b98d3487b6e3b72863670eb57c3b4ff> /usr/lib/system/libsystem_trace.dylib
 0x18608a000 - 0x18608ffff libunwind.dylib arm64  <a9da0d0735093dc38005623608c0f71e> /usr/lib/system/libunwind.dylib
 0x186090000 - 0x186090fff libvminterpose.dylib arm64  <c1577063af17384b8091f9923960a1f1> /usr/lib/system/libvminterpose.dylib
 0x186091000 - 0x1860bbfff libxpc.dylib arm64  <1732d812fa793d159965e668759a42df> /usr/lib/system/libxpc.dylib
 0x1860bc000 - 0x1862ddfff libicucore.A.dylib arm64  <32c272e1e9f735aba4c16a17580f13e3> /usr/lib/libicucore.A.dylib
 0x1862de000 - 0x1862effff libz.1.dylib arm64  <c402ff63470b34df8634f2078cd151e1> /usr/lib/libz.1.dylib
 0x1862f0000 - 0x186685fff CoreFoundation arm64  <846f4b1542383c98991c1314902e3d72> /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation
 0x186686000 - 0x186696fff libbsm.0.dylib arm64  <b7a56e43a852351d8a2dab94c7fc04e6> /usr/lib/libbsm.0.dylib
 0x186697000 - 0x186697fff libenergytrace.dylib arm64  <6adeca3b70ed33dda70a16353c5ef6ce> /usr/lib/libenergytrace.dylib
 0x186698000 - 0x18671dfff IOKit arm64  <938f5f32ece43551a651b777bd44d431> /System/Library/Frameworks/IOKit.framework/Versions/A/IOKit
 0x18671e000 - 0x186807fff libxml2.2.dylib arm64  <33530216f58333d993d4acb846c63aac> /usr/lib/libxml2.2.dylib
 0x186808000 - 0x186815fff libbz2.1.0.dylib arm64  <35c6ddde076638589f755656ac0058ce> /usr/lib/libbz2.1.0.dylib
 0x186816000 - 0x18682efff liblzma.5.dylib arm64  <7d5815f117103d15a67fd30b3375b11b> /usr/lib/liblzma.5.dylib
 0x18682f000 - 0x18698cfff libsqlite3.dylib arm64  <eac933b033d43444ae182e2d7de6137f> /usr/lib/libsqlite3.dylib
 0x18698d000 - 0x1869b3fff libMobileGestalt.dylib arm64  <dc43249a916a3294a98ae31871591dd9> /usr/lib/libMobileGestalt.dylib
 0x1869b4000 - 0x186d20fff CFNetwork arm64  <1b8095865d8a3b84a9cbe0d5d0354fc1> /System/Library/Frameworks/CFNetwork.framework/CFNetwork
 0x186d21000 - 0x18701cfff Foundation arm64  <dad046ce90513de69c6ca86d7184b7c2> /System/Library/Frameworks/Foundation.framework/Foundation
 0x18701d000 - 0x18710bfff Security arm64  <11c28a235f0d34a483d4c0c6d3a72617> /System/Library/Frameworks/Security.framework/Security
 0x18710c000 - 0x187178fff SystemConfiguration arm64  <e4021e13feec30af8e612a49060b1ad1> /System/Library/Frameworks/SystemConfiguration.framework/SystemConfiguration
 0x187179000 - 0x1871affff libCRFSuite.dylib arm64  <faed949ffe90353091a2916aef415302> /usr/lib/libCRFSuite.dylib
 0x1871b0000 - 0x1871b0fff libapple_crypto.dylib arm64  <7b69ce788b6f3bd581d76b857760c614> /usr/lib/libapple_crypto.dylib
 0x1871b1000 - 0x1871c7fff libapple_nghttp2.dylib arm64  <ff88135792b639679509b309f0c0cad9> /usr/lib/libapple_nghttp2.dylib
 0x1871c8000 - 0x1871f1fff libarchive.2.dylib arm64  <957aea53942d3afc91420044f6ae5112> /usr/lib/libarchive.2.dylib
 0x1871f2000 - 0x1872a3fff libboringssl.dylib arm64  <a515a4c41d7337dd85ed1db0cb3d1a09> /usr/lib/libboringssl.dylib
 0x1872a4000 - 0x1872bbfff libcoretls.dylib arm64  <c2287d06413f32c2aee0e6c3313d98c7> /usr/lib/libcoretls.dylib
 0x1872bc000 - 0x1872bdfff libcoretls_cfhelpers.dylib arm64  <79276edd953836b698947c5db28c83ad> /usr/lib/libcoretls_cfhelpers.dylib
 0x1872be000 - 0x1872bffff liblangid.dylib arm64  <11d94ede5ab1300a820d96e3374f53fa> /usr/lib/liblangid.dylib
 0x1872c0000 - 0x187393fff libnetwork.dylib arm64  <e4a37ecffec3327bb37e3fd427c92b87> /usr/lib/libnetwork.dylib
 0x187394000 - 0x1873c6fff libpcap.A.dylib arm64  <419a8dd2325a326c81b4b02d849ce562> /usr/lib/libpcap.A.dylib
 0x1873c7000 - 0x1873fbfff libusrtcp.dylib arm64  <227ec64866e53676828e76f89c1e4928> /usr/lib/libusrtcp.dylib
 0x1873fc000 - 0x187405fff IOSurface arm64  <76764bfa34e8365e8263c8ec57868e70> /System/Library/Frameworks/IOSurface.framework/IOSurface
 0x187406000 - 0x1874abfff libBLAS.dylib arm64  <05ecdd31f9573a069c0e8b3d610bbc3f> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBLAS.dylib
 0x1874ac000 - 0x1877dbfff libLAPACK.dylib arm64  <3e55f73c8a4c329d8bb7f5e58ed687c3> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLAPACK.dylib
 0x1877dc000 - 0x187a48fff vImage arm64  <7fabce5d1fe83c38aa998440146eb09b> /System/Library/Frameworks/Accelerate.framework/Frameworks/vImage.framework/vImage
 0x187a49000 - 0x187a5afff libSparseBLAS.dylib arm64  <88335b280db13b3d812ee89998bc363c> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparseBLAS.dylib
 0x187a5b000 - 0x187a7ffff libvMisc.dylib arm64  <20da313fe2343db189a04c72928eb120> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvMisc.dylib
 0x187a80000 - 0x187aaafff libBNNS.dylib arm64  <19481dd658fb3f949cc1874250cfead5> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libBNNS.dylib
 0x187aab000 - 0x187ac0fff libLinearAlgebra.dylib arm64  <0f6e8d5a7dd8384ebb8a873c2caa7ad7> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libLinearAlgebra.dylib
 0x187ac1000 - 0x187ac5fff libQuadrature.dylib arm64  <124a57c41e3e3956b46e10d49ddf8fe1> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libQuadrature.dylib
 0x187ac6000 - 0x187b1cfff libSparse.dylib arm64  <c7def66b4a4c3f29b55fcbdcf881e3f2> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libSparse.dylib
 0x187b1d000 - 0x187b95fff libvDSP.dylib arm64  <4bf846f47a0e309db93bbbc791720463> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/libvDSP.dylib
 0x187b96000 - 0x187b96fff vecLib arm64  <86cdd48d842334dd831b1fc0e2b0270f> /System/Library/Frameworks/Accelerate.framework/Frameworks/vecLib.framework/vecLib
 0x187b97000 - 0x187b97fff Accelerate arm64  <01d515c3376c332799f14694934ed70b> /System/Library/Frameworks/Accelerate.framework/Accelerate
 0x187b98000 - 0x187badfff libcompression.dylib arm64  <b1a3a8c4b3a6301da874dc2af4a50920> /usr/lib/libcompression.dylib
 0x187bae000 - 0x1880f2fff CoreGraphics arm64  <1d111fedd821351f8d22fe4f2840719a> /System/Library/Frameworks/CoreGraphics.framework/CoreGraphics
 0x1880f3000 - 0x1880f8fff IOAccelerator arm64  <ff13ef43a6f73cdaa52ce9abae404d3c> /System/Library/PrivateFrameworks/IOAccelerator.framework/IOAccelerator
 0x1880f9000 - 0x1880fefff libCoreFSCache.dylib arm64  <ac1882646b0c3cccb69dfc5246995396> /System/Library/Frameworks/OpenGLES.framework/libCoreFSCache.dylib
 0x1880ff000 - 0x188199fff Metal arm64  <5810b5432e4c34cf9f254b60f64e5e89> /System/Library/Frameworks/Metal.framework/Metal
 0x18819a000 - 0x1881adfff GraphicsServices arm64  <208776c1b0a73cb4827546b47cdfca63> /System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices
 0x1881ae000 - 0x188306fff MobileCoreServices arm64  <ceed55b6a3083c1b93152daff0cc2ab5> /System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices
 0x188307000 - 0x188309fff IOSurfaceAccelerator arm64  <4feb745bfd323a0da4357d5fc65f54b2> /System/Library/PrivateFrameworks/IOSurfaceAccelerator.framework/IOSurfaceAccelerator
 0x18830a000 - 0x18834bfff AppleJPEG arm64  <823dea35af383cf987bdd6d2b653d41f> /System/Library/PrivateFrameworks/AppleJPEG.framework/AppleJPEG
 0x18834c000 - 0x1888fcfff ImageIO arm64  <090201d1811b3083b64c89e1c9694585> /System/Library/Frameworks/ImageIO.framework/ImageIO
 0x1888fd000 - 0x188961fff BaseBoard arm64  <5c05976a04053b179505341ce299f130> /System/Library/PrivateFrameworks/BaseBoard.framework/BaseBoard
 0x188962000 - 0x188979fff AssertionServices arm64  <eac3dcdc35103304b3dc72ce0c8a0a07> /System/Library/PrivateFrameworks/AssertionServices.framework/AssertionServices
 0x18897a000 - 0x188982fff CorePhoneNumbers arm64  <3f42ae84ea833c52b8cd522108d259b2> /System/Library/PrivateFrameworks/CorePhoneNumbers.framework/CorePhoneNumbers
 0x188983000 - 0x1889c7fff AppSupport arm64  <ac0c26eabc2e3737b4b0f6e524f9c54f> /System/Library/PrivateFrameworks/AppSupport.framework/AppSupport
 0x1889c8000 - 0x1889e0fff CrashReporterSupport arm64  <28a3b2eac04b3ec482639475186d309c> /System/Library/PrivateFrameworks/CrashReporterSupport.framework/CrashReporterSupport
 0x1889e1000 - 0x1889e6fff AggregateDictionary arm64  <60d5c87dbe3e3c48a3e0b91ae2cad9e7> /System/Library/PrivateFrameworks/AggregateDictionary.framework/AggregateDictionary
 0x1889e7000 - 0x188a68fff libTelephonyUtilDynamic.dylib arm64  <46d5ede9f7fe338c97671721fbad60cc> /usr/lib/libTelephonyUtilDynamic.dylib
 0x188a69000 - 0x188a88fff ProtocolBuffer arm64  <8963290d47123204921f70ae9bb9612a> /System/Library/PrivateFrameworks/ProtocolBuffer.framework/ProtocolBuffer
 0x188a89000 - 0x188ab4fff MobileKeyBag arm64  <d8ce3418ab5b3832906e77aa9e3c9aad> /System/Library/PrivateFrameworks/MobileKeyBag.framework/MobileKeyBag
 0x188ab5000 - 0x188ae9fff BackBoardServices arm64  <2b30bebf7da7379db6b6538ca533fd6b> /System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices
 0x188aea000 - 0x188b45fff FrontBoardServices arm64  <5bff8665f950326a8ad86be07a66a48a> /System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices
 0x188b46000 - 0x188b82fff SpringBoardServices arm64  <415fae0b30393d0d92bf23dc22de21c4> /System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices
 0x188b83000 - 0x188b91fff PowerLog arm64  <83c23c8e972438b79e688c4d455b1b5e> /System/Library/PrivateFrameworks/PowerLog.framework/PowerLog
 0x188b92000 - 0x188baffff CommonUtilities arm64  <dcd92acd9a14345e9b63801706e4a82e> /System/Library/PrivateFrameworks/CommonUtilities.framework/CommonUtilities
 0x188bb0000 - 0x188bbbfff liblockdown.dylib arm64  <2fec7d5a759c32f293936f78220c1fc4> /usr/lib/liblockdown.dylib
 0x188bbc000 - 0x188ebefff CoreData arm64  <b972e9f8b7de3a568acb4ed8216f0b76> /System/Library/Frameworks/CoreData.framework/CoreData
 0x188ebf000 - 0x188ec5fff TCC arm64  <06384f9076eb3e06a7d2a883d6007b3d> /System/Library/PrivateFrameworks/TCC.framework/TCC
 0x188ec6000 - 0x188ecdfff libcupolicy.dylib arm64  <e6b23e36e1a335ad974f6b35ba2b033b> /usr/lib/libcupolicy.dylib
 0x188ece000 - 0x188f5afff CoreTelephony arm64  <e63112dd995a333ca54d3f6d60ae18c7> /System/Library/Frameworks/CoreTelephony.framework/CoreTelephony
 0x188f5b000 - 0x188fb1fff Accounts arm64  <3f8159d915823051a17536c6b21e81a9> /System/Library/Frameworks/Accounts.framework/Accounts
 0x188fb2000 - 0x188fdbfff AppleSauce arm64  <4b81009f219e3f3794d3ff93ddcd0547> /System/Library/PrivateFrameworks/AppleSauce.framework/AppleSauce
 0x188fdc000 - 0x188fe4fff DataMigration arm64  <e98907cbf67e35ca998fab8c64f92eea> /System/Library/PrivateFrameworks/DataMigration.framework/DataMigration
 0x188fe5000 - 0x188febfff Netrb arm64  <9f8ebcf99af53a7087add608b6fb9c2a> /System/Library/PrivateFrameworks/Netrb.framework/Netrb
 0x188fec000 - 0x18901ffff PersistentConnection arm64  <c00b010864ca32d78dadbf487d8fb9f7> /System/Library/PrivateFrameworks/PersistentConnection.framework/PersistentConnection
 0x189020000 - 0x189031fff libmis.dylib arm64  <1885af6da98d3997abff70b062548010> /usr/lib/libmis.dylib
 0x189032000 - 0x189132fff ManagedConfiguration arm64  <b37e31dfe0b4340f86d707d09f210545> /System/Library/PrivateFrameworks/ManagedConfiguration.framework/ManagedConfiguration
 0x189133000 - 0x189138fff libReverseProxyDevice.dylib arm64  <d6cfe7cabd433fe5a8bd77fba606479a> /usr/lib/libReverseProxyDevice.dylib
 0x189139000 - 0x18914afff libamsupport.dylib arm64  <48a69db1f895324d8debac434913a4e5> /usr/lib/libamsupport.dylib
 0x18914b000 - 0x189150fff libCoreVMClient.dylib arm64  <017bacb6b7e83fdda154764e0492358a> /System/Library/Frameworks/OpenGLES.framework/libCoreVMClient.dylib
 0x189151000 - 0x189152fff libCVMSPluginSupport.dylib arm64  <79591b228c133dc7a93fcdb529f5c1c9> /System/Library/Frameworks/OpenGLES.framework/libCVMSPluginSupport.dylib
 0x189153000 - 0x189156fff libutil.dylib arm64  <b82455fcf10c34ddbe0871d7e6998071> /usr/lib/libutil.dylib
 0x189157000 - 0x189198fff libGLImage.dylib arm64  <9ac83085267733acb9bc652dd70dcc2d> /System/Library/Frameworks/OpenGLES.framework/libGLImage.dylib
 0x189199000 - 0x189209fff APFS arm64  <a56b1bb534613a6da50d098073bfe7a7> /System/Library/PrivateFrameworks/APFS.framework/APFS
 0x18920a000 - 0x18923bfff MediaKit arm64  <3b199804d91e3afcb08a2698062cff65> /System/Library/PrivateFrameworks/MediaKit.framework/MediaKit
 0x18923c000 - 0x189254fff libSERestoreInfo.dylib arm64  <25abfa4121b03a25b5422fa6ba16b695> /usr/lib/updaters/libSERestoreInfo.dylib
 0x189259000 - 0x189295fff DiskImages arm64  <c78798bf47263e8d8ba1403fa9753a41> /System/Library/PrivateFrameworks/DiskImages.framework/DiskImages
 0x189296000 - 0x1892a0fff libGFXShared.dylib arm64  <425823fa3f663785af7e7e72e74a2eee> /System/Library/Frameworks/OpenGLES.framework/libGFXShared.dylib
 0x1892a1000 - 0x1892e7fff libauthinstall.dylib arm64  <51c4aba4fa7f376dbee944ee466f56c1> /usr/lib/libauthinstall.dylib
 0x1892e8000 - 0x1892f0fff IOMobileFramebuffer arm64  <e77d0723d9ca3bd49aed5354023ac013> /System/Library/PrivateFrameworks/IOMobileFramebuffer.framework/IOMobileFramebuffer
 0x1892f1000 - 0x1892fcfff OpenGLES arm64  <e2869e8b79a63c9ca81291d5a6714ef6> /System/Library/Frameworks/OpenGLES.framework/OpenGLES
 0x1892fd000 - 0x189384fff ColorSync arm64  <174c246784a4333db343d29ca59affcb> /System/Library/PrivateFrameworks/ColorSync.framework/ColorSync
 0x189385000 - 0x1893affff CoreVideo arm64  <69c63a3d198a34de9f343ad8e8181059> /System/Library/Frameworks/CoreVideo.framework/CoreVideo
 0x1893b0000 - 0x1893b1fff libCTGreenTeaLogger.dylib arm64  <e5ad1c68080134edaf25ccea03e08a52> /usr/lib/libCTGreenTeaLogger.dylib
 0x1893b2000 - 0x189514fff CoreAudio arm64  <7ad95e096a253ff58b74a03e3f252a4e> /System/Library/Frameworks/CoreAudio.framework/CoreAudio
 0x189515000 - 0x189543fff CoreAnalytics arm64  <be12a86b5538303fadce7fb5cac04ff5> /System/Library/PrivateFrameworks/CoreAnalytics.framework/CoreAnalytics
 0x189544000 - 0x189547fff UserFS arm64  <52342f6a8e273c7391e327deb2ab82e4> /System/Library/PrivateFrameworks/UserFS.framework/UserFS
 0x189548000 - 0x1896bbfff CoreMedia arm64  <ac554e80365734d88d03dc363716a637> /System/Library/Frameworks/CoreMedia.framework/CoreMedia
 0x1896bc000 - 0x1896cefff libprotobuf-lite.dylib arm64  <2ed5fd0c82f8337b96e17a7b1846b878> /usr/lib/libprotobuf-lite.dylib
 0x1896cf000 - 0x189733fff libprotobuf.dylib arm64  <0a967243387e32aeb31a8b5ceeac3718> /usr/lib/libprotobuf.dylib
 0x189734000 - 0x189a11fff libAWDSupportFramework.dylib arm64  <db0f4644d45938e39bdace7ecc5c6eeb> /usr/lib/libAWDSupportFramework.dylib
 0x189a12000 - 0x189a58fff WirelessDiagnostics arm64  <903eca346b9a357eb9d6939c5a2da02d> /System/Library/PrivateFrameworks/WirelessDiagnostics.framework/WirelessDiagnostics
 0x189a59000 - 0x189b11fff VideoToolbox arm64  <d18b9ae1333e3227806dea21be49a8d2> /System/Library/Frameworks/VideoToolbox.framework/VideoToolbox
 0x189b12000 - 0x189c1dfff libFontParser.dylib arm64  <d502b1402ada3abfb17dd35e3b6ccfd3> /System/Library/PrivateFrameworks/FontServices.framework/libFontParser.dylib
 0x189c1e000 - 0x189c1ffff FontServices arm64  <0c499009fcb931d18cf6bfdc1af51684> /System/Library/PrivateFrameworks/FontServices.framework/FontServices
 0x189c20000 - 0x189d6ffff CoreText arm64  <3cb200fd11ab3102b01a9aab2730a871> /System/Library/Frameworks/CoreText.framework/CoreText
 0x189d80000 - 0x189d88fff RTCReporting arm64  <2710371c2d763bde99c5e3ce763cebf9> /System/Library/PrivateFrameworks/RTCReporting.framework/RTCReporting
 0x189d89000 - 0x189df7fff CoreBrightness arm64  <ac737e260dda338687d75091a549cbe7> /System/Library/PrivateFrameworks/CoreBrightness.framework/CoreBrightness
 0x189df8000 - 0x189e03fff libAudioStatistics.dylib arm64  <f144e9f449f0366d903c07dc7042e1bb> /usr/lib/libAudioStatistics.dylib
 0x189e04000 - 0x18a354fff AudioToolbox arm64  <32fc6cb60ab531a892ee7db6030dcee9> /System/Library/Frameworks/AudioToolbox.framework/AudioToolbox
 0x18a355000 - 0x18a585fff QuartzCore arm64  <0e7efded7b69323094142d876969c3ff> /System/Library/Frameworks/QuartzCore.framework/QuartzCore
 0x18a586000 - 0x18a591fff MediaAccessibility arm64  <c08f2d8d22ad32e696bbfe19c1f00132> /System/Library/Frameworks/MediaAccessibility.framework/MediaAccessibility
 0x18a685000 - 0x18a6a1fff NetworkStatistics arm64  <67dd3f90fc933567af5f336e36a3f69a> /System/Library/PrivateFrameworks/NetworkStatistics.framework/NetworkStatistics
 0x18a6a2000 - 0x18a6b7fff MPSCore arm64  <2b8da25dee323cb0871eb5839266c6b1> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSCore.framework/MPSCore
 0x18a6b8000 - 0x18a71cfff MPSImage arm64  <c54b04d27c9639958942abdf2b0aa21a> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSImage.framework/MPSImage
 0x18a71d000 - 0x18a73dfff MPSMatrix arm64  <7f20afd02853372eaeac3604ab798ca9> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSMatrix.framework/MPSMatrix
 0x18a73e000 - 0x18a74cfff CoreAUC arm64  <24c1f952294f3d769d3b2d3d3df002f9> /System/Library/PrivateFrameworks/CoreAUC.framework/CoreAUC
 0x18a74d000 - 0x18add2fff MediaToolbox arm64  <a6ee11cab3b83741ba23824098c0765d> /System/Library/Frameworks/MediaToolbox.framework/MediaToolbox
 0x18add3000 - 0x18ae99fff MPSNeuralNetwork arm64  <e9b49812899e39b98e4f16b1e4929859> /System/Library/Frameworks/MetalPerformanceShaders.framework/Frameworks/MPSNeuralNetwork.framework/MPSNeuralNetwork
 0x18ae9a000 - 0x18ae9afff MetalPerformanceShaders arm64  <968c8d8650a6345e99c11a24d4908a14> /System/Library/Frameworks/MetalPerformanceShaders.framework/MetalPerformanceShaders
 0x18ae9b000 - 0x18b2cefff FaceCore arm64  <ce35d4571e5032258ca94f23e53a1a16> /System/Library/PrivateFrameworks/FaceCore.framework/FaceCore
 0x18b2cf000 - 0x18b2dcfff GraphVisualizer arm64  <9731b1a2362e35e5b47495a6f4a49d31> /System/Library/PrivateFrameworks/GraphVisualizer.framework/GraphVisualizer
 0x18b2dd000 - 0x18b482fff libFosl_dynamic.dylib arm64  <8dade3ca46eb36ba918cabaae25e7279> /usr/lib/libFosl_dynamic.dylib
 0x18b483000 - 0x18b6e8fff CoreImage arm64  <708015be329e31eabd93df07dec18a17> /System/Library/Frameworks/CoreImage.framework/CoreImage
 0x18b907000 - 0x18b929fff PlugInKit arm64  <9a0fc8c71da23cbaac48ef7266d3b164> /System/Library/PrivateFrameworks/PlugInKit.framework/PlugInKit
 0x18bee5000 - 0x18bf0afff StreamingZip arm64  <dacb59888b7f31a39e95cf0ea3a741ef> /System/Library/PrivateFrameworks/StreamingZip.framework/StreamingZip
 0x18bf6c000 - 0x18bf73fff SymptomDiagnosticReporter arm64  <c1f54dbc49c53abbbe651644b610c4b0> /System/Library/PrivateFrameworks/SymptomDiagnosticReporter.framework/SymptomDiagnosticReporter
 0x18c876000 - 0x18c88dfff MobileAsset arm64  <4c1572513f59389e84081a755103547b> /System/Library/PrivateFrameworks/MobileAsset.framework/MobileAsset
 0x18cdf7000 - 0x18d82cfff JavaScriptCore arm64  <e5e2cd24ee8e39a5908c7512a93dbc4f> /System/Library/Frameworks/JavaScriptCore.framework/JavaScriptCore
 0x18d833000 - 0x18d8adfff libate.dylib arm64  <bb4173dd632f3d9baf425608ec3ad1a7> /usr/lib/libate.dylib
 0x18d8ae000 - 0x18d950fff TextureIO arm64  <d5473c10ba4c31f29814c5940d66f041> /System/Library/PrivateFrameworks/TextureIO.framework/TextureIO
 0x18d951000 - 0x18da1bfff CoreUI arm64  <8e5892440df03a3f9342ba386f3c8012> /System/Library/PrivateFrameworks/CoreUI.framework/CoreUI
 0x18da1c000 - 0x18da25fff MobileIcons arm64  <8d72c789b63c3d9eb0236814a909a473> /System/Library/PrivateFrameworks/MobileIcons.framework/MobileIcons
 0x18da35000 - 0x18da8efff TextInput arm64  <5e1c89ec1e1c310caa79b707ee359048> /System/Library/PrivateFrameworks/TextInput.framework/TextInput
 0x18daee000 - 0x18db83fff FileProvider arm64  <81d2b19a8fe03251acd4b816dfd08908> /System/Library/Frameworks/FileProvider.framework/FileProvider
 0x18dd5d000 - 0x18dd71fff libAccessibility.dylib arm64  <04185c7e9c1e340da5c2bccb2ca2b1af> /usr/lib/libAccessibility.dylib
 0x18dd72000 - 0x18e1cafff libwebrtc.dylib arm64  <9c780252d56939d1bc15e93523a790a2> /System/Library/PrivateFrameworks/WebCore.framework/Frameworks/libwebrtc.dylib
 0x18e22c000 - 0x18f649fff WebCore arm64  <efe4ff69a90238958ea8d3cfe946c772> /System/Library/PrivateFrameworks/WebCore.framework/WebCore
 0x18f64a000 - 0x18f7bdfff WebKitLegacy arm64  <3806037d085136809a33f0fd56b200e2> /System/Library/PrivateFrameworks/WebKitLegacy.framework/WebKitLegacy
 0x18f8d8000 - 0x18f904fff UserNotifications arm64  <1acc9bc755ae33708ad7a5eeadf6b8ec> /System/Library/Frameworks/UserNotifications.framework/UserNotifications
 0x18f98a000 - 0x18f9ddfff DocumentManager arm64  <6753460517ce35f1a33d34fe9819ca81> /System/Library/Frameworks/UIKit.framework/Frameworks/DocumentManager.framework/DocumentManager
 0x18f9de000 - 0x190a63fff UIKit arm64  <1ae0c6d9279b3ac4a7e10bf3a63a0692> /System/Library/Frameworks/UIKit.framework/UIKit
 0x190a64000 - 0x190a75fff DocumentManagerCore arm64  <051e2c78e43f3700af20321c6e289322> /System/Library/PrivateFrameworks/DocumentManagerCore.framework/DocumentManagerCore
 0x190a76000 - 0x190a7afff HangTracer arm64  <f66e4e75e8073b9290d9723d324edb88> /System/Library/PrivateFrameworks/HangTracer.framework/HangTracer
 0x190a7b000 - 0x190acdfff PhysicsKit arm64  <469bfd49cb5636da8a84d78ba983642c> /System/Library/PrivateFrameworks/PhysicsKit.framework/PhysicsKit
 0x190ace000 - 0x190ad0fff StudyLog arm64  <9b3ba7d0a1dd3b1da0b003c214cfc816> /System/Library/PrivateFrameworks/StudyLog.framework/StudyLog
 0x190ad1000 - 0x190bb1fff UIFoundation arm64  <fa727d25bd7432f3afe426784ff9cdd1> /System/Library/PrivateFrameworks/UIFoundation.framework/UIFoundation
 0x190cc0000 - 0x190d89fff Network arm64  <64b464c46498305a8f6d0522bf0e112b> /System/Library/PrivateFrameworks/Network.framework/Network
 0x195a29000 - 0x195a2efff ConstantClasses arm64  <ba66372594cb3a2b8db141e6eb25ce2e> /System/Library/PrivateFrameworks/ConstantClasses.framework/ConstantClasses
 0x1a5baa000 - 0x1a5bbefff libCGInterfaces.dylib arm64  <fa21578480423183907f3bd84e809893> /System/Library/Frameworks/Accelerate.framework/Frameworks/vImage.framework/Libraries/libCGInterfaces.dylib
 0x1a874b000 - 0x1a875cfff libGSFontCache.dylib arm64  <50b74f1d848d3bb693fedc5ec5abcdd4> /System/Library/PrivateFrameworks/FontServices.framework/libGSFontCache.dylib
 0x1a875d000 - 0x1a878ffff libTrueTypeScaler.dylib arm64  <368042c6615c3311b21a920e048e67f9> /System/Library/PrivateFrameworks/FontServices.framework/libTrueTypeScaler.dylib
 0x1ade77000 - 0x1adea8fff libclosured.dylib arm64  <aefc8840686d30a88277d7efcb70abaf> /usr/lib/closure/libclosured.dylib
 
 EOF
 
*/

@end