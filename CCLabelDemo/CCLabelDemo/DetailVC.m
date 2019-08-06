//
//  DetailVC.m
//  CCLabelDemo
//
//  Created by dengyouhua on 2019/7/11.
//  Copyright © 2019 cc | ccworld1000@gmail.com. All rights reserved.
//

#import "DetailVC.h"
#import "CCLabel.h"

static CGFloat const kEspressoDescriptionTextFontSize = 17.0f;

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

static inline NSRegularExpression * ParenthesisRegularExpression() {
    static NSRegularExpression *_parenthesisRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _parenthesisRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"\\([^\\(\\)]+\\)" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _parenthesisRegularExpression;
}

@interface DetailVC () <CCLabelDelegate, UIActionSheetDelegate>
@property (nonatomic, copy) NSString *espressoDescription;
@property (nonatomic) CCLabel *attributedLabel;
@end

@implementation DetailVC
@synthesize espressoDescription = _espresso;
@synthesize attributedLabel = _attributedLabel;

- (id)initWithEspressoDescription:(NSString *)espresso {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) {
        return nil;
    }
    
    self.espressoDescription = espresso;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Espresso", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat offset = 15;
    self.attributedLabel = [[CCLabel alloc] initWithFrame:CGRectMake(offset, offset, [UIScreen mainScreen].bounds.size.width - offset * 2, [UIScreen mainScreen].bounds.size.height - offset * 2 )];
    [self.view addSubview:self.attributedLabel];
    
    
    self.attributedLabel.delegate = self;
    UIFont *f = [UIFont systemFontOfSize:kEspressoDescriptionTextFontSize];
    self.attributedLabel.font = f;
    self.attributedLabel.textColor = [UIColor darkGrayColor];
    self.attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributedLabel.lineSpacing = -100;
    self.attributedLabel.maximumLineHeight = f.lineHeight;
    self.attributedLabel.minimumLineHeight = f.lineHeight;
    self.attributedLabel.numberOfLines = 0;
    self.attributedLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    self.attributedLabel.highlightedTextColor = [UIColor whiteColor];
    self.attributedLabel.shadowColor = [UIColor colorWithWhite:0.87f alpha:1.0f];
    self.attributedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.attributedLabel.verticalAlignment = CCLabelVerticalAlignmentTop;
    
    [self.attributedLabel setText:self.espressoDescription afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        
        NSRegularExpression *regexp = NameRegularExpression();
        NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
        UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:kEspressoDescriptionTextFontSize];
        CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (boldFont) {
            [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)boldFont range:nameRange];
            CFRelease(boldFont);
        }
        
        [mutableAttributedString replaceCharactersInRange:nameRange withString:[[[mutableAttributedString string] substringWithRange:nameRange] uppercaseString]];
        
        regexp = ParenthesisRegularExpression();
        [regexp enumerateMatchesInString:[mutableAttributedString string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult *result, __unused NSMatchingFlags flags, __unused BOOL * stop) {
            UIFont *italicSystemFont = [UIFont italicSystemFontOfSize:kEspressoDescriptionTextFontSize];
            CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)italicSystemFont.fontName, italicSystemFont.pointSize, NULL);
            if (italicFont) {
                [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)italicFont range:result.range];
                CFRelease(italicFont);
                
                [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorAttributeName range:result.range];
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor grayColor] CGColor] range:result.range];
            }
        }];
        
        return mutableAttributedString;
    }];
    
    NSRegularExpression *regexp = NameRegularExpression();
    NSRange linkRange = [regexp rangeOfFirstMatchInString:self.espressoDescription options:0 range:NSMakeRange(0, [self.espressoDescription length])];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", [self.espressoDescription substringWithRange:linkRange]]];
    [self.attributedLabel addLinkToURL:url withRange:linkRange];
}

#pragma mark - CCLabelDelegate

- (void)attributedLabel:(__unused CCLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSString *title = [url absoluteString];
    
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"Open Link in Safari" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:title] options:@{} completionHandler:nil];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        ;
    }]];
    
    [self presentViewController:ac animated:NO completion:nil];
}

@end
