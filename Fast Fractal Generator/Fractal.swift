//
//  Fractal.swift
//  Fast Fractal Generator
//
//  Created by Shahar Sandhaus on 6/25/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import Foundation;
import CoreGraphics;
import OpenGLES;

class Fractal {
    
    var vbo: GLuint = 0;
    var shader: GLuint = 0;
    
    var aspectLoc: GLint = 0;
    var scaleLoc: GLint = 0;
    var windowLoc: GLint = 0;
    
    var cLoc: GLint = 0;
    var maxIterationLoc: GLint = 0;
    var colorSchemeLoc: GLint = 0;
    var colorInsideLoc: GLint = 0;
    var colorOutsideLoc: GLint = 0;
    var scLoc: GLint = 0;
    var offLoc: GLint = 0;
    
    func getShaderSourcePointer(str: String) -> UnsafePointer<UnsafePointer<GLchar>?> {
        let nsVertSource: NSString = NSString(string: str);
        
        let pVertShader: UnsafeMutablePointer<UnsafePointer<GLchar>?> = UnsafeMutablePointer<UnsafePointer<GLchar>?>.allocate(capacity: 1);
        pVertShader.pointee? = nsVertSource.utf8String!;
        
        return UnsafePointer<UnsafePointer<GLchar>?>.init(pVertShader);
    }
    
    func readFile(name: String, type: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: type);
        
        do {
            return try String(contentsOfFile: (path)!);
        } catch {
            print("Error reading file!");
        }
        
        return "";
    }
    
    func setup(size: CGPoint) {
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
        
        let vertShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER));
        
        glShaderSource(vertShader, 1, getShaderSourcePointer(str: readFile(name: "vert", type: "glsl")), nil);
        
        glCompileShader(vertShader);
        
        let fragShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER));
        glShaderSource(fragShader, 1, getShaderSourcePointer(str: readFile(name: "frag", type: "glsl")), nil);
        glCompileShader(fragShader);
        
        let pStatus: UnsafeMutablePointer<GLint> = UnsafeMutablePointer<GLint>.allocate(capacity: 1);
        glGetShaderiv(fragShader, GLenum(GL_COMPILE_STATUS), pStatus);
        let status: GLint = pStatus.pointee;
        
        if(status==0){
            print("Fragment Error");
            
            /*
            glGetShaderiv(vertShader,GL_INFO_LOG_LENGTH, &status);
            
            if (status>1){
                int length;
                glGetShaderInfoLog(vertShader, 0, &length, NULL);
                char* logInfo = malloc(sizeof(char) * length);
                glGetShaderInfoLog(vertShader, sizeof(char) * length, NULL, logInfo);
                
                log_c(logInfo);
            }
            
            glDeleteShader(vertShader);
 */
        }
        
        shader = glCreateProgram();
        
        glAttachShader(shader, vertShader);
        glAttachShader(shader, fragShader);
        
        glBindAttribLocation(shader, 0, "pos");
        
        glLinkProgram(shader);
        
        aspectLoc = glGetUniformLocation(shader, "aspect");
        scaleLoc = glGetUniformLocation(shader, "scale");
        windowLoc = glGetUniformLocation(shader, "window");
        
        cLoc = glGetUniformLocation(shader, "c");
        maxIterationLoc = glGetUniformLocation(shader, "maxIteration");
        colorSchemeLoc = glGetUniformLocation(shader, "colorScheme");
        colorInsideLoc = glGetUniformLocation(shader, "colorInside");
        colorOutsideLoc = glGetUniformLocation(shader, "colorOutside");
        scLoc = glGetUniformLocation(shader, "sc");
        offLoc = glGetUniformLocation(shader, "off");
        
        let aspect: Float = Float(size.y/size.x);
        
        var aspectX: Float = 0;
        var aspectY: Float = 0;
        
        if(aspect >= 1) {
            aspectX = 1;
            aspectY = aspect;
        } else {
            aspectX = 1.0/aspect;
            aspectY = 1;
        }
        
        glUseProgram(shader);
        
        glUniform2f(aspectLoc, aspectX, aspectY);
        glUniform1f(scaleLoc, 1);
        glUniform2f(windowLoc, 0, 0);
        
        glUniform2f(cLoc, 0, 0);
        glUniform1i(maxIterationLoc, 50);
        glUniform1i(colorSchemeLoc, 2);
        glUniform3f(colorInsideLoc, 0, 0, 0);
        glUniform3f(colorOutsideLoc, 0, 1, 0);
        
        glUniform2f(scLoc, 1, 0);
        glUniform4f(offLoc, 0, 0, 0, 0);
        
        glUseProgram(0);
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
