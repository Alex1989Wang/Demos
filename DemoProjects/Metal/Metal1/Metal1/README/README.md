#  Metal基础

## 基本概念

### GPU vs CPU
A GPU is a specialized hardware component that can process images, videos and massive amounts of data really fast. This is called throughput. The throughput is measured by the amount of data processed in a specific unit of time. GPU的设计就是为了高并发，因此会相比CPU而言有更多的核。

A CPU, on the other hand, can’t handle massive amounts of data really fast, but it can process many sequential tasks (one after another) really fast. The time necessary to process a task is called latency. 而CPU的设计是为了低延时。

[图片](./Images/gpu-vs-cpu.png)

The GPU is represented in Metal by an object that conforms to the MTLDevice protocol. The MTLDevice is responsible for creating and managing a variety of persistent and transient objects used to process data and render it to the screen. There is a single method call to create a default system device, which is the only way that the GPU can be represented in software. This ensures safety when sending data to and from the GPU.

### Render

MTLDevice(GPU) - Command Queues -> Command Buffers -> Command Encoders

Command buffers are executed in the order in which they were committed to the command queue. Command queues are expensive to create, so they are reused rather than destroyed when they have finished executing their current instructions. command queue对象的创建是比较耗费性能的，因此在metal的渲染周期中，一般是重用创建的command queue而不是每次新建。

The pipeline performs a series of steps:
1. Data preparation for the GPU 2. Vertex processing
3. Primitive assembly
4. Fragment shading
5. Raster output

#### Pipeline State

MTLRenderPipelineState是pipeline state的协议。包含了一系列可以给command encoder配置的state信息。

#### vertex and fragment shaders

shader：顶点和颜色着色器。vertex shader主要用来计算图形的定点坐标。vertex shader接收的参数可能是每一个vertex。也可能是整个有顶点组成的基本对象（点、线、triangle）。Fragment shadeer的功能是fill primitives with color. 

#### In Metal, you need to know two conceptual worlds: world space and camera space.

这就好比是你在看一个影片，在电视屏幕的可视范围内，你能看到的内容可能包含演员，他们所在场景的一些家具摆设。但是你没有看到的内容还包括：灯光、摄影团队等。对于metal而言，metal是不会渲染超出视图范围，或者遮挡的物体的。

下面的概念很重要：
After the vertex shader is done processing the vertex data, that data needs to be assembled into primitives. Metal supports three basic types of primitives:
• Points: Consist of one vertex
• Lines: Consist of two vertices
• Triangles: Composed of three vertices

### Rasterization栅格化

rasterization projects the primitives to the screen instead of scanning the object from behind. It then loops over the pixels and checks to see whether an object is present in the pixel. If it is, the pixel is filled with the object’s color.
栅格化就是将所有的基础对象（点、线、三角）投射到屏幕上，而不是像ray tracing一样从后方扫描图片。然后，栅格化会对每一个像素进行循环计算，检查这个像素是否是属于某个物体；如果是，就将该像素的颜色配置为该物体颜色。

### Fragment Shader
If there are no lighting or filters or other effects applied to the object, then the fragment shader requires a simple pass through program that receives and returns the color passed to the shader by the rasterizer. 对于没有滤镜、光线和其他效果施加的物体而言，fragment shader只是将rasterizer输出的颜色直接返回而已。The fragment shader is the last stop for modifying image data before it is sent to the frame buffer to output. Fragment shader图像在发送给帧缓冲和其他输入渠道的之前的最后一个步骤。There are at least two frame buffers at any given point in time. One is actively being presented to the screen while the other is being drawn to. 所谓的double或者tripple-buffering。

The way we humans conceptualize graphics is purely visual. A computer, however, must numerically represent images.

3D images are broken into triangles. These triangles are described using vertices. These vertices are written to a vertex buffer and fed to a vertex shader. Then, the computer determines whether the triangle appears on the screen. It culls any objects that don’t appear. These objects are then refined by the fragment shader, where effects can be applied. Lastly, the data describing each pixel is sent to a frame buffer, where the image is drawn before it is presented to the screen.


### 坐标

Metal utilizes a normalized coordinate system. Metal’s normalized coordinate system is two units by two units by one unit. This means that the upper-left front corner’s coordinate is (1, 1, 1). The lower-right corner’s coordinate is (−1, −1, 0). The center of your coordinate system is represented by (0, 0, 0.5) .
