attribute vec2 position;

varying vec4 ptp;

uniform vec2 aspect;
uniform float scale;
uniform vec2 window;

void main() {
    vec2 finalPos = ((position + 1.0) / scale) - 1.0;
    
    gl_Position = vec4(finalPos, 0.0, 1.0);
    
    ptp = vec4(0);
    ptp.x = (position.x + window.x)*aspect.x*0.5 + 0.5;
    ptp.y = (position.y + window.y)*aspect.y*0.5 + 0.5;
    ptp.z = 0.0;
    ptp.w = 0.0;
}
