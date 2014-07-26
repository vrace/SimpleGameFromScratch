//
//  Shader.fsh
//  Shape
//
//  Created by Liu Yang on 7/25/14.
//
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
