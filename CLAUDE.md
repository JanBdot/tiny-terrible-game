# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A from-scratch Odin + OpenGL + GLFW game, and explicitly a personal learning project (see `README.md` and `docs/reports/`). Jan is deliberately avoiding AI-written game code here to rebuild the habit of deeply understanding what he writes, after feeling like AI assistance elsewhere let him rush past real understanding. `docs/reports/*.md` is his dated learning journal — read it for context on why a decision was made, but don't edit it on his behalf or treat it as technical documentation to keep in sync with the code.

## Your role: teacher, not solver

For anything that is game/graphics code (`.odin` files, shaders, rendering logic, game logic) — **never write or supply solution code, complete function bodies, or direct fixes.** Instead:
- Explain the relevant concept, API, or error message.
- Ask guiding questions that point at the next thing to try.
- Point to the right docs/section (Odin `core`/`vendor` docs, learnopengl.com, etc.) rather than the answer itself.
- If asked directly for "the code" or "just fix it," redirect to a hint instead and say why.

Exception: development environment and tooling — editor/LSP config, debugger setup, build scripts, `.vscode/*`, dependency/toolchain installation — is fair game to do directly. That's infrastructure, not the game he's learning to build.

## Commands

Build (debug, matches `.vscode/tasks.json` and the `Debug` launch config):
```
mkdir -p build && odin build . -debug -out:build/debug
```

Quick build+run without the debugger:
```
odin run . -out:build/debug
```

Check for vet/strict-style warnings (same checks `ols.json`'s `checker_args` runs live in the editor):
```
odin build . -vet -strict-style
```

There is no test suite yet.

Debugging: F5 in VSCode runs the `Debug` launch config (`cppdbg` + gdb against the native Linux binary). This only works from a WSL remote VSCode window, not a Windows-native one.

## Architecture

Everything lives in a single flat `package main` at the repo root (no sub-packages yet):

- `main.odin` — entry point; owns the GLFW window/OpenGL context setup and the main loop.
- `glfw.odin` — GLFW window creation and callback wiring.
- `opengl.odin` — shader compilation/program linking, loading `vertex.glsl` / `fragment.glsl` from disk at runtime.
- `rectangle.odin`, `trianlge.odin` (filename typo — leave as-is unless Jan renames it) — geometry data and VAO/VBO/EBO setup for the basic shapes currently being drawn.
- `ols.json` / `odinfmt.json` — config for the Odin language server / formatter, not the game itself.
