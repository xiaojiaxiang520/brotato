shader_type canvas_item; // 声明这是一个 CanvasItem 着色器
// shader_type canvas_item;  // 2D 图形
// shader_type spatial;      // 3D 图形
// shader_type particles;    // 粒子系统
//  内置变量
// TEXTURE: 纹理采样结果
// COLOR: 原始颜色
// UV: 纹理坐标 (0.0 到 1.0)
// SCREEN_UV: 屏幕坐标
// VERTEX: 顶点位置
// 找ai学习
void vertex() {
	// 每个顶点都会调用一次
    // 用于修改顶点位置、法线等
}

void fragment() {
	// 每个像素都会调用一次
    // 用于设置像素的颜色和效果
	COLOR = vec4(1.0, 1.0, 1.0, texture(TEXTURE, UV).a);
}

//void light() {
//	// 每个光照影响的像素都会调用一次
//    // 用于自定义光照处理
//}
