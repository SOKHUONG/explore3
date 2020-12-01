uniform float time;
uniform float progress;
uniform sampler2D t;
uniform vec4 resolution;
varying vec2 vUv;
varying vec3 vPosition;

float PI = 3.14159265358979323846264338327;

void main() {

    // vec2 newUv = vPosition.xy / vec2(480. * 1.5, 820. * 1.5) + vec2(0.5);

    vec4 tt = texture2D(t, vUv);

    // gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
    // gl_FragColor = vec4(vUv, 0, 1.0);
    gl_FragColor = tt;

}