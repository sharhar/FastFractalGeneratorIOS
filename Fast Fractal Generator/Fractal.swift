//
//  Fractal.swift
//  Fast Fractal Generator
//
//  Created by Shahar Sandhaus on 6/25/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import Foundation;
import OpenGLES;

class Fractal {
    
    var vbo: GLuint = 0;
    var shader: GLuint = 0;
    
    func getShaderSourcePointer(str: String) -> UnsafePointer<UnsafePointer<GLchar>?> {
        let nsVertSource: NSString = NSString(string: str);
        
        let pVertShader: UnsafeMutablePointer<UnsafePointer<GLchar>?> = UnsafeMutablePointer<UnsafePointer<GLchar>?>.allocate(capacity: 1);
        pVertShader.pointee? = nsVertSource.utf8String!;
        
        return UnsafePointer<UnsafePointer<GLchar>?>.init(pVertShader);
    }
    
    func setup() {
        glClearColor(0.2, 0.3, 0.8, 1.0);
        
        let verts: [Float] = [
            -1, -1,
             1,  1,
             1, -1,
            
            -1, -1,
             1,  1,
            -1,  1
        ];
        
        let vboa: UnsafeMutablePointer<GLuint> = UnsafeMutablePointer<GLuint>.allocate(capacity: 1);
        glGenBuffers(1, vboa);
        vbo = vboa.pointee;
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo);
        glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * 12, verts, GLenum(GL_STATIC_DRAW));
        
        let vertSource: String =
                                "attribute vec2 pos;" +
                                "varying vec2 uv;" +
                                "void main() {" +
                                "   gl_Position = vec4(pos.xy, 0.0, 1.0);" +
                                "   uv = (pos + 1.0)/2.0;" +
                                "}";
        
        let vertShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER));
        
        glShaderSource(vertShader, 1, getShaderSourcePointer(str: vertSource), nil);
        
        glCompileShader(vertShader);
        
        let fragSource: String =
                "precision highp float;" +
                "varying vec2 uv;" +
                "void main() {" +
                "   gl_FragColor = vec4(uv.xy, 0.0, 1.0);" +
                "}";
        
        let fragShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER));
        glShaderSource(fragShader, 1, getShaderSourcePointer(str: fragSource), nil);
        glCompileShader(fragShader);
        
        shader = glCreateProgram();
        
        glAttachShader(shader, vertShader);
        glAttachShader(shader, fragShader);
        
        glBindAttribLocation(shader, 0, "pos");
        
        glLinkProgram(shader);
    }
    
    func render() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT));
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo);
        
        glUseProgram(shader);
        
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil);
        
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 6);
    }
    
}
