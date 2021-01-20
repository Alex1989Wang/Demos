//
//  PassThrough.metal
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/19.
//

#include <metal_stdlib>
using namespace metal;
#include "VertexData.h"

struct RasterizerData {
    float4 position [[ position ]];
    float2 texture_coord;
};

vertex RasterizerData pass_through_vertex(device const VertexData *vertexes [[ buffer(0)]],
                                          uint vid [[ vertex_id ]]) {
    RasterizerData output;
    output.position = float4(vertexes[vid].position, 1);
    output.texture_coord = float2(vertexes[vid].textCoord);
    return output;
}

fragment float4 pass_through_fragment(RasterizerData in [[stage_in]],
                                      texture2d<half> text [[texture(0)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    const half4 sample = text.sample(textureSampler, in.texture_coord);
    return float4(sample);
}
