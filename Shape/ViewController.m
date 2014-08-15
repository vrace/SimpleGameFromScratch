//
//  ViewController.m
//  Shape
//
//  Created by Liu Yang on 7/25/14.
//
//

#import "ViewController.h"
#import "Sprite.h"

@import GLKit;

// Our screen resolution
int ScreenWidth = 320;
int ScreenHeight = 480;

@interface ViewController () {
}

@property (strong, nonatomic) EAGLContext *context;
@property Sprite *sprite;  // our sprite

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // Save our screen resolution
    ScreenWidth = (int)view.frame.size.width;
    ScreenHeight = (int)view.frame.size.height;
    
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (GLKTextureInfo*)textureFromImage:(NSString*)imageName
{
    NSError *err;
    GLKTextureInfo *tex = nil;
    
    // Find the path in our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    
    // Load the texture from file
    if (path)
        tex = [GLKTextureLoader textureWithContentsOfFile:path options:nil error:&err];
    
    if (!tex)
        NSLog(@"Can't load texture %@", imageName);
    
    return tex;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    // Enable blend so that we can see through transparent picture
    glEnable(GL_BLEND);
    // Set blend function to best representing transparent picture
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Setup our sprite
    GLKTextureInfo *texture = [self textureFromImage:@"Spaceship"];
    self.sprite = [Sprite spriteWithTexture:texture];
    self.sprite.size = GLKVector2Make(50, 50);
    
    // Setup projection matrix so that we could use real screen resolution
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();  // Set to identity first. IMPORTANT!
    glOrthof(ScreenWidth * -0.5f, ScreenWidth * 0.5f,   // left - right (x axis)
             ScreenHeight * -0.5f, ScreenHeight * 0.5f, // bottom - up (y axis)
             -1.0f, 1.0f);  // near - far (z axis)
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear screen
    glClearColor(0.4f, 0.6f, 0.9f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Reset Model View Matrix
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    [self.sprite draw];
}

@end
