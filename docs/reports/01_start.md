# Let's get started

## 14.08.2026

We need a language to start, so first we need to find some candidates. We definetly want a statically typed language and prefer compiled and simple tool chains. Experience is a factor, but we're willing to learn.

Candidate List:

- Go
- Typescript
- C++
- Odin
- Zig
- C#
- Kotlin

### Reasoning with myself:

I had a job as Go Backend dev in the past and really enjoyed writing Go, but it seems like it's not made for writing game system stuff. I don't want to rule it out, because on paper it ticks all the boxes, but I think when it comes to UI stuff it really lacks and I don't want a client/server system.
I'm currently mostly working with Typescript, so I put it on the list, but I don't think I will use it for this project. I don't want to build in the browser and I want to keep the toolchain minimal.
C++ is on the list and actually a hot candidate, but then again, why not just go with Odin which has more QoL features aimed at GameDev and is not that evolved, which scares me of C++.
My hope is with a language like Odin (or also Zig) to get started quickly and especially with Odin have more dense material on game dev, where as with C++ there is just so much.
C# and Kotlin seem like the easier choices that suit pretty well, which is not a bad thing. But they are also very much general purpose and very strong on OOP and Domain Programming, where I'm looking for something more system level.
As I write this down, I can see that I argument myself into Odin.

_So next step --> write Hello World, compile and run in Odin and come back!_

### Odin Review

So intallation was pretty straight-forward, it has a lot of dependencies and I had a bit of trouble installing llvm. The installation script actually worked fine, but I missed, that it installs under the path llvm-config-<version>.

Installing Odin itself and running/building the first Hello World was very straight forward and I'm at the variable part of the overview and I'm already loving the parallels to Go.

So today I will go through the _Overview_ and then make a final verdict, but I think I'm already pretty much sold on Odin.

### Let's get started (for real)

I read trough a good chunck of the overview and then scrolled some more. From that Odin feels very similar to Go. So I decided to just start and come back to the docs when necessary.

But getting started sounds easier as it actually is.
What am I going to do? I remember from Computer Graphics in Uni, that we started with just a triangle. So to display a triangle I need a window first.
I could do it with just coords or in the terminal, but soon we would need a window anyway.

I thought there would maybe be a core lib that already has something, but a short google search showed, that I probably need a Grapics Library.

I found a [Github Gist](https://gist.github.com/SorenSaket/155afe1ec11a79def63341c588ade329) that uses OpenGL and will go with this for now and see if it works and maybe reconsider later. I'm a bit scared how windows will work, because I'm building in Ubuntu with WSL inside Windows. But we'll get to this soon enough.

Before I continue... I know what OpenGl is, that it provides an excensive library for everything computer graphic related. But I wouldn't know how to create a UI window with it.
So then I noticed, that it also imports `GLFW` from a vendor package (I think vendor packages are like extended library provided).

### Understanding copy pasta

As I wrote I found the gist with a minimal OpenGL program in Odin using GLFW for UI. So far I didn't add any code, I just read through it and try to understand how the pieces fit together. I also looked at the configuration, but I will not remember most of these.
I do understand I have a basic loop now. I can init and I can update values, which are then drawn and buffered.
I also understand, that next to my Odin binary is where the core and vendor packages are and Odin will link with those on compile. My LSP is working well now and I think we can now draw out first triangle. For that we need to get to know OpenGl a bit better.
