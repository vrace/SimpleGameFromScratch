//
//  Sprite.h
//  Shape
//
//  Created by Liu Yang on 8/4/14.
//
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface Sprite : NSObject

@property GLKTextureInfo *texture;
@property GLKVector2 position;
@property GLKVector2 size;

+ (id)spriteWithTexture:(GLKTextureInfo*)texture;

- (id)initWithTexture:(GLKTextureInfo*)texture;
- (void)draw;

@end
