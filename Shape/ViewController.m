//
//  ViewController.m
//  Shape
//
//  Created by Liu Yang on 7/25/14.
//
//

#import "ViewController.h"

@import GLKit;

// This is our vertex format
// It keeps us away from raw float array
typedef struct tagVertex
{
    // coordinate of our vertex
    float x, y;
    
    // coordinate of our texture
    // normally we use 'uv' to indicate a texture coordinate
    // uv has a range of (0,0) to (1,1)
    float u, v;
} Vertex;

@interface ViewController () {
}

@property (strong, nonatomic) EAGLContext *context;
@property GLKTextureInfo *texture;  // our texture

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
    
    self.texture = [self textureFromImage:@"Spaceship"];
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
    glClearColor(0.4f, 0.6f, 0.9f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Our sprite (a quad with a picture)
    Vertex v[] =
    {
        // x        y       u       v
        
        // first triangle
        { -0.5f,    0.5f,   0.0f,   0.0f },     // top left of quad
        { -0.5f,    -0.5f,  0.0f,   1.0f },     // bottom left of quad
        { 0.5f,     -0.5f,  1.0f,   1.0f },     // bottom right of quad
        
        // second triangle
        { -0.5f,    0.5f,   0.0f,   0.0f },     // top left of quad
        { 0.5f,     -0.5f,  1.0f,   1.0f },     // bottom right of quad
        { 0.5f,     0.5f,   1.0f,   0.0f },     // top right of quad
    };
    
    // Enable texture and bind
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, self.texture.name);
    
    // We have vertex and texture coord in our data
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // Send the data
    glVertexPointer(2, GL_FLOAT, sizeof(Vertex), v);
    glTexCoordPointer(2, GL_FLOAT, sizeof(Vertex), &v[0].u);
    
    // And draw
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    // Clean up
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glDisable(GL_TEXTURE_2D);
}

@end
