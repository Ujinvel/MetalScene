/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Shaders
 */

#include <metal_stdlib>

using namespace metal;

//*** Input data
struct SVertexIn {
  packed_float3 position;
  packed_float3 textPos;
  packed_float4 color;
  
  float isUserLocation;
};

//*** Data for basicFragment
struct SVertexOut {
  float4 position [[position]];
  float3 text;
  float4 color;
};

//*** While contains only the matrix of normalization
struct SUniforms {
  float4x4 ndcMatrix;
  
  float2 userlocation;// location.x, location.y
  float2 translation;// translation.x, translation.y
  float3 scaleFromPoint;// scale, point.x, point.y
};

//*** Vertex shader for drawing a triangle
vertex SVertexOut basicVertex(const device SVertexIn *vertex_array [[buffer(0)]],
                              const device SUniforms &uniforms [[buffer(1)]],
                              unsigned int vid [[vertex_id]]) {
  SVertexOut vertexOut;
  
  SVertexIn vertexIn = vertex_array[vid];
  float3 position    = vertexIn.position;
  
  // positioning of markers user
  if (vertexIn.isUserLocation == 1) {
    position[0] = position[0] + uniforms.userlocation[0];
    position[1] = position[1] + uniforms.userlocation[1];
  }
  
  // scale
  if (uniforms.scaleFromPoint[0] > 1.0) {
    float scale          = uniforms.scaleFromPoint[0];
    float scaledCenterX  = uniforms.scaleFromPoint[1];
    float scaledCenterY  = uniforms.scaleFromPoint[2];
    
    float xPos = position[0] * scale + scaledCenterX * (1 - scale);
    float yPos = position[1] * scale + scaledCenterY * (1 - scale);
    
    position[0] = xPos;
    position[1] = yPos;
  }
  
  vertexOut.position = uniforms.ndcMatrix * float4(position, 1.0);// Normalize the coordinates
  vertexOut.color    = vertexIn.color;
  vertexOut.text     = vertexIn.textPos;
  
  return vertexOut;
}
//-----------------------------------------------------------------------------------

//*** Shader for drawing fragment(pixel)(http://metalbyexample.com/translucency-and-transparency/)
//fragment half4 basicFragment(SVertexOut interpolated [[stage_in]]) {
fragment half4 basicFragment(SVertexOut interpolated [[stage_in]],
                             sampler samplr [[sampler(0)]],
                             texture2d<float, access::sample> texture [[texture(0)]]) {
  if (interpolated.text[2] == 0.0) {
    half sAlpha = interpolated.color[3];

    if (sAlpha != 1) {
      //*** alpha blending
      half3 destinationColor = half3(0, 0, 0);// destination is black
      // source
      half sRed   = interpolated.color[0];
      half sGreen = interpolated.color[1];
      half sBlack = interpolated.color[2];
      // blended color
      half3 color = sAlpha * half3(sRed, sGreen, sBlack) + (1 - sAlpha) * destinationColor;

      return half4(color, sAlpha);
    }
    
    return half4(interpolated.color);
  } else {
      float4 color = float4(0, 0, 0, 1);//uniforms.foregroundColor;
      // Outline of glyph is the isocontour with value 50%
      float edgeDistance = 0.5;
      // Sample the signed-distance field to find distance from this fragment to the glyph outline
      float sampleDistance = texture.sample(samplr, float2(interpolated.text[0], interpolated.text[1])).r;
      // Use local automatic gradients to find anti-aliased anisotropic edge width, cf. Gustavson 2012
      float edgeWidth = 0.75 * length(float2(dfdx(sampleDistance), dfdy(sampleDistance)));
      // Smooth the glyph edge by interpolating across the boundary in a band with the width determined above
      float insideness = smoothstep(edgeDistance - edgeWidth, edgeDistance + edgeWidth, sampleDistance);
    
      return half4(color.r, color.g, color.b, insideness);
    }
  
   return half4(interpolated.color);
}
//-----------------------------------------------------------------------------------

