precision mediump float;
uniform sampler2D tex;
uniform float dim;

void main() {
    vec4 pix = texture2D(tex, gl_FragCoord.xy / textureSize(tex, 0));
    gl_FragColor = vec4(pix.rgb * dim, pix.a);
}

