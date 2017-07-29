//
//  Fractal.swift
//  Fast Fractal Generator
//
//  Created by Shahar Sandhaus on 6/25/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES

class Fractal {

    static let RENDER_BUFFER: Int = 0
    static let RENDER_DOWNSCALE: Int = -1
    static let RENDER_UPSCALE: Int = 16

    var renderMode: Int = RENDER_UPSCALE

    var vbo: GLuint = 0
    var shader: GLuint = 0

    var aspectLoc: GLint = 0
    var cLoc: GLint = 0
    var maxIterationLoc: GLint = 0
    var scLoc: GLint = 0
    var offLoc: GLint = 0
    var scaleLoc: GLint = 0
    var colorSchemeLoc: GLint = 0
    var colorInsideLoc: GLint = 0
    var colorOutsideLoc: GLint = 0
    var transLoc: GLint = 0
    var windowLoc: GLint = 0
    var dpLoc: GLint = 0
    var texLoc: GLint = 0

    var aspectX: Float = 0
    var aspectY: Float = 0

    var startTime: TimeInterval = 0
    var frames: UInt32 = 0
    var FPS: UInt32 = 0

    var fbo: GLuint = 0
    var renderBuffer: GLuint = 0
    var fboTex: GLuint = 0

    var fbof: GLuint = 0
    var renderBufferf: GLuint = 0
    var fboTexf: GLuint = 0

    var fbob: GLuint = 0
    var renderBufferb: GLuint = 0
    var fboTexb: GLuint = 0

    var colorScheme: GLint = 2

    func readFile(name: String, type: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: type)

        do {
            print("Reading shader")
            return try String(contentsOfFile: path!)
        } catch {
            print("Error reading file!")
        }
        print("Hello")
        return ""
    }

    func initModel() {
        let verts: [Float] = [
            -1, -1,
            1, 1,
            1, -1,

            -1, -1,
            1, 1,
            -1, 1,
        ]

        let vboa: UnsafeMutablePointer<GLuint> = UnsafeMutablePointer<GLuint>.allocate(capacity: 2)
        glGenBuffers(1, vboa)
        vbo = vboa.pointee
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), 4 * 12, verts, GLenum(GL_STATIC_DRAW))
    }

    func initShaders() {
        let vertShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))

        let vertSource = readFile(name: "vert", type: "glsl")
        let nsVertSource = NSString(string: vertSource)
        var cVertSource = nsVertSource.utf8String

        glShaderSource(vertShader, 1, &cVertSource, nil)
        glCompileShader(vertShader)

        let pStatus: UnsafeMutablePointer<GLint> = UnsafeMutablePointer<GLint>.allocate(capacity: 1)
        glGetShaderiv(vertShader, GLenum(GL_COMPILE_STATUS), pStatus)
        var status: GLint = pStatus.pointee

        if status == 0 {
            print("Vertex Error")

            glGetShaderiv(vertShader, GLenum(GL_INFO_LOG_LENGTH), pStatus)
            status = pStatus.pointee

            if status > 1 {
                let pLog: UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(status))
                glGetShaderInfoLog(vertShader, GLsizei(status), nil, pLog)

                let log: String = String(cString: UnsafePointer<CChar>.init(pLog))

                print(log)
            }

            glDeleteShader(vertShader)
        }

        let fragShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))

        let fragSource = readFile(name: "frag", type: "glsl")
        let nsFragSource = NSString(string: fragSource)
        var cFragSource = nsFragSource.utf8String

        glShaderSource(fragShader, 1, &cFragSource, nil)
        glCompileShader(fragShader)

        glGetShaderiv(fragShader, GLenum(GL_COMPILE_STATUS), pStatus)

        if status == 0 {
            print("Fragment Error")

            glGetShaderiv(fragShader, GLenum(GL_INFO_LOG_LENGTH), pStatus)
            status = pStatus.pointee

            if status > 1 {
                let pLog: UnsafeMutablePointer<GLchar> = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(status))
                glGetShaderInfoLog(fragShader, GLsizei(status), nil, pLog)

                let log: String = String(cString: UnsafePointer<CChar>.init(pLog))

                print(log)
            }

            glDeleteShader(fragShader)
        }

        shader = glCreateProgram()

        glAttachShader(shader, vertShader)
        glAttachShader(shader, fragShader)

        glBindAttribLocation(shader, 0, "pos")

        glLinkProgram(shader)

        aspectLoc = glGetUniformLocation(shader, "aspect")
        cLoc = glGetUniformLocation(shader, "c")
        maxIterationLoc = glGetUniformLocation(shader, "maxIteration")
        colorSchemeLoc = glGetUniformLocation(shader, "colorScheme")
        colorInsideLoc = glGetUniformLocation(shader, "colorInside")
        colorOutsideLoc = glGetUniformLocation(shader, "colorOutside")
        scaleLoc = glGetUniformLocation(shader, "scale")
        scLoc = glGetUniformLocation(shader, "sc")
        offLoc = glGetUniformLocation(shader, "off")
        windowLoc = glGetUniformLocation(shader, "window")
        dpLoc = glGetUniformLocation(shader, "dp")

        glUseProgram(shader)

        glUniform2f(cLoc, 0, 0)
        glUniform1i(maxIterationLoc, 25)
        glUniform1i(colorSchemeLoc, colorScheme)
        glUniform3f(colorInsideLoc, 0, 0, 0)
        glUniform3f(colorOutsideLoc, 0, 1, 0)
        glUniform1i(dpLoc, 0)

        glUniform2f(aspectLoc, aspectX, aspectY)
        glUniform1f(scaleLoc, 4)
        glUniform2f(windowLoc, 0, 0)

        glUniform2f(scLoc, 1, 0)
        glUniform4f(offLoc, 0, 0, 0, 0)

        glUseProgram(0)
    }

    func setup(size: CGPoint) {
        glClearColor(0.2, 0.3, 0.8, 1.0)

        startTime = Date().timeIntervalSinceReferenceDate

        let aspect: Float = Float(size.y / size.x)

        if aspect >= 1 {
            aspectX = 1
            aspectY = aspect
        } else {
            aspectX = 1.0 / aspect
            aspectY = 1
        }

        initModel()
        initShaders()
    }

    func changeColor() {
        colorScheme = colorScheme + 1
        if colorScheme == 6 {
            colorScheme = 0
        }
        renderMode = Fractal.RENDER_UPSCALE
    }

    func render() {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)

        glUseProgram(shader)

        glUniform1i(colorSchemeLoc, colorScheme)

        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)

        glDrawArrays(GLenum(GL_TRIANGLES), 0, 6)

        frames += 1
        let currentTime: TimeInterval = Date().timeIntervalSinceReferenceDate
        if currentTime - startTime >= 1 {
            FPS = frames
            frames = 0
            print("\(FPS)\tExtra: \(currentTime - startTime - 1)")
            startTime = currentTime
        }
    }
}
