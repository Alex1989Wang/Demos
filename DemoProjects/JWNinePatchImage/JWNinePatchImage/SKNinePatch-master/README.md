# SKNinePatch

## Introduction

9-patch image and label classes that handle all four sides of a 9-patch image, that is both the image and content stretchable regions. At most one stretchable region on each side is assumed.

## Example

```
#import "SKLabel.h"

@property(nonatomic, weak) IBOutlet SKLabel *label;

@synthesize label;

NSString *path = [[NSBundle mainBundle] pathForResource:@"foo.9@2x" ofType:@"png"];
SKNinePatchImage *background =
        [[SKNinePatchImage alloc] initWithContentsOfFile:path];
[[self label] setBackground:background];
```
