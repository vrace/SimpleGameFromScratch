//
//  Sprite.m
//  Shape
//
//  Created by Liu Yang on 8/4/14.
//
//

#import "Sprite.h"

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

@implementation Sprite

- (id)initWithTexture:(GLKTextureInfo*)texture
{
    self = [super init];
    
    if (self)
    {
        self.texture = texture;
        self.size = GLKVector2Make(texture.width, texture.height);
        self.position = GLKVector2Make(0,0);
    }
    
    return self;
}

+ (id)spriteWithTexture:(GLKTextureInfo*)texture
{
    return [[self alloc] initWithTexture:texture];
}

- (void)draw
{
    if (!self.texture)
    {
        NSLog(@"Sprite texture not set");
        return;
    }
    
    float hw = self.size.x * 0.5f;
    float hh = self.size.y * 0.5f;
    
    // Our sprite (a quad with a picture)
    Vertex v[] =
    {
        // x        y           u       v
        
        // first triangle
        { -hw,      hh,         0.0f,   0.0f },     // top left of quad
        { -hw,      -hh,        0.0f,   1.0f },     // bottom left of quad
        { hw,       -hh,        1.0f,   1.0f },     // bottom right of quad
        
        // second triangle
        { -hw,      hh,         0.0f,   0.0f },     // top left of quad
        { hw,       -hh,        1.0f,   1.0f },     // bottom right of quad
        { hw,       hh,         1.0f,   0.0f },     // top right of quad
    };
    
    // Save the Model View Matrix
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    
    // Doing transform
    glTranslatef(self.position.x, self.position.y, 0);
    glRotatef(self.rotation, 0, 0, 1);
    
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
    
    // Restore matrix
    glPopMatrix();
}

@end
