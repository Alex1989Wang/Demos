//
//  Triangle.metal
//  Metal1
//
//  Created by JiangWang on 2020/5/25.
//  Copyright © 2020 JiangWang. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/*
 This vertex shader receives two parameters. The first parameter is the position of each vertex. The [[ buffer(0) ]] code specifies to the vertex shader to pull its data from the first vertex buffer you sent to the shader. Because you’ve created only one vertex buffer, it’s easy to figure out which one comes first. The second parameter is the index of the vertex within the vertex array.
 第一个参数是每个顶点的位置：The [[ buffer(0) ]] code，标明了vertex shader需要从你给shader发送的第一个vertex buffer中获取数据。
 第二个参数是在vertex数组中的vertex的index。
 */
vertex float4 basic_vertex(const device packed_float3* vertex_array [[ buffer(0) ]], unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 1.0);
}

/*
 The fragment shader is responsible for calculating the color of each pixel on the screen. It calculates the color according to the color data it receives from the vertices. If one vertex is red and another one is green, each pixel between those vertices will be colored on a gradient. The amount of red and green is calculated on the basis of how close or far away each vertex is.
 */
fragment half4 basic_fragment() {
    return half4(1.0);
    /*
     这里返回的是[1.0, 1.0, 1.0, 1.0]
     */
}

