#  Shaders的基础

## 基本概念

Shaders are small programs that are run on the GPU. Even though you can set up most of the work in your main program and not the shaders, it is silly to force the CPU to do this work when the GPU is uniquely suited to doing this work efficiently. Shader是在GPU上跑的子程序。

Shader程序中的方法签名通常看起来是这样的：
shaderType returnType shaderName(parameter1, parameter2, etc....)
{ 

}

对于metal来讲：
The shaders need to receive information from the vertex buffers. The vertex buffers need to have memory allocated and the vertex data bound to it. The buffers also have to be added to the argument table so they can be accessed by the shaders. 

### argument table


