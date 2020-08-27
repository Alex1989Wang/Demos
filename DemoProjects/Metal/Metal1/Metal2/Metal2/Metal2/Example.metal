//
//  Example.metal
//  Metal2
//
//  Created by JiangWang on 2020/5/25.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


/*
 The method signature for all your shaders will look something like this:
 
 shaderType returnType shaderName(parameter1, parameter2, etc....) {
 
 }
 */

/*
 vertex shader
 */

struct VertexInOut
{
   float4  position [[position]];
   float4  color;
};

/*
 The second component of the shader file is the vertex shader. The output of the vertex shader is the struct previously created. It also takes in three parameters:
 • vid: This parameter is the vertex ID, which connects to the vertex buffer to bring in the current vertex.
 • position: This parameter connects to the attribute table. In the default Metal template, there are two attributes in the attribute table: position and color. The position buffer is the first attribute. Here, you are passing into the vertex shader what the current position is for the current vertex.
 • color: This is the second attribute from the attribute table.
 

 // generate a large enough buffer to allow streaming vertices for 3
 vertexBuffer = device.makeBuffer(length: ConstantBufferSize, options: [])
 vertexBuffer.label = "vertices"
 
 let vertexColorSize = vertexData.count * MemoryLayout<Float>.size
 vertexColorBuffer = device.makeBuffer(bytes: vertexColorData, length: vertexColorSize, options: [])
 vertexColorBuffer.label = "colors"
 
 renderEncoder.setVertexBuffer(vertexBuffer, offset: 256*bufferIndex, at: 0)
 renderEncoder.setVertexBuffer(vertexColorBuffer, offset:0 , at: 1)
 
 */
vertex VertexInOut passThroughVertex(uint vid [[ vertex_id ]],
                                     constant packed_float4* position [[ buffer(0) ]],
                                     constant packed_float4* color [[ buffer(1) ]])
{
    VertexInOut outVertext;
    outVertext.position = position[vid];
    outVertext.color = color[vid];
    return outVertext;
};

/*
 The third structure in this pass-through shader example is the fragment shader. The fragment shader takes in the struct that was returned by the vertex shader. The fragment shader is concerned only with the color of each pixel, so it cherry picks the color component of the struct as its return value.
 */
fragment half4 passThroughFragment(VertexInOut inFrag [[ stage_in ]]) {
    return half4(inFrag.color);
};
