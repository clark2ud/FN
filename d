<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kernel Core</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #070809;
      --surface: #0c0e10;
      --surface-2: #101315;
      --surface-3: #14171a;
      --line: #1b2024;
      --line-soft: #131619;
      --text: #e6e9eb;
      --muted: #6e777d;
      --dim: #3f464b;
      --acid: #c4ae90;
      --acid-dim: #c8ab83;
      --red: #ff4d6d;
      --gold: #ffd166;
      --radius: 10px;
      --max: 1160px;
      --ease: cubic-bezier(.22, 1, .36, 1);
      --w: var(--muted);
      --plus: var(--acid);
      --v: var(--gold);
      --wr: var(--red);
      --eac: #4da6ff;
      --be: #ffd166;
      --success: #39ff88;
      --warn: #ffcc29;
      --beige: #d8bd9b;
      --beige-soft: rgba(216, 189, 155, .18);
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    * {
      cursor: crosshair;
    }

    a, button, .co-opt, .logo {
      cursor: pointer;
    }

    body::before {
      content: "";
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      height: 6px;
      z-index: 999;
      background: linear-gradient(90deg, transparent 0%, rgba(216, 189, 155, .45) 20%, rgba(234, 213, 184, .9) 45%, #fff7eb 55%, rgba(234, 213, 184, .9) 65%, rgba(216, 189, 155, .45) 80%, transparent 100%);
      box-shadow: 0 0 45px 14px rgba(216, 189, 155, .22), 0 0 90px 34px rgba(216, 189, 155, .12);
      filter: blur(8px);
      pointer-events: none;
      animation: borderGlow 10s ease-in-out infinite;
    }

    @keyframes borderGlow {
      0%, 100% { filter: blur(8px) brightness(1); }
      50% { filter: blur(14px) brightness(1.18); }
    }

    .top-blur {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      height: 220px;
      z-index: 998;
      pointer-events: none;
      background: radial-gradient(ellipse 80% 55% at 50% -10%, rgba(216, 189, 155, .28), rgba(176, 141, 103, .12) 40%, rgba(216, 189, 155, .05) 65%, transparent);
      filter: blur(88px);
      animation: topBlurPulse 10s ease-in-out infinite;
    }

    @keyframes topBlurPulse {
      0%, 100% { opacity: .78; }
      50% { opacity: 1; }
    }

    body::after {
      content: "+";
      position: fixed;
      z-index: 1000;
      pointer-events: none;
      color: var(--beige);
      font: 600 20px/1 "JetBrains Mono", monospace;
      text-shadow: 0 0 14px var(--beige), 0 0 28px rgba(216, 189, 155, .5);
      transform: translate(10px, 8px);
      transition: color .15s;
    }

    body:has(a:hover)::after,
    body:has(button:hover)::after,
    body:has(.co-opt:hover)::after {
      color: #fff0d8;
    }

    html {
      scroll-behavior: smooth;
    }

    body {
      background: var(--bg);
      color: var(--text);
      font-family: "Space Grotesk", sans-serif;
      overflow-x: hidden;
    }

    ::selection {
      background: var(--acid);
      color: #000;
    }

    a {
      color: inherit;
      text-decoration: none;
    }

    button {
      font: inherit;
      cursor: pointer;
    }

    img {
      display: block;
    }

    .container {
      width: min(var(--max), calc(100% - 40px));
      margin: auto;
    }

    ::-webkit-scrollbar {
      width: 10px;
    }

    ::-webkit-scrollbar-track {
      background: var(--bg);
    }

    ::-webkit-scrollbar-thumb {
      background: #22282c;
      border-radius: 99px;
      border: 2px solid var(--bg);
    }

    ::-webkit-scrollbar-thumb:hover {
      background: #31383d;
    }

    .rv {
      opacity: 0;
      transform: translateY(34px);
      transition: opacity .9s var(--ease), transform .9s var(--ease);
    }

    .rv.in {
      opacity: 1;
      transform: none;
    }

    .rv-d1 { transition-delay: .12s; }
    .rv-d2 { transition-delay: .24s; }
    .rv-d3 { transition-delay: .36s; }
    .rv-d4 { transition-delay: .48s; }

    nav {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 100;
      background: rgba(7, 8, 9, .88);
      backdrop-filter: blur(18px);
      border-bottom: 1px solid var(--line-soft);
    }

    .nav-inner {
      height: 62px;
      width: min(var(--max), calc(100% - 40px));
      margin: auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    #logoBtn {
      transition: opacity .3s, transform .3s var(--ease);
    }

    #logoBtn:hover {
      opacity: .85;
      transform: scale(1.04) translateY(-1px);
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      font-weight: 700;
      font-size: 15px;
      letter-spacing: .05em;
      cursor: pointer;
      transition: opacity .2s;
    }

    .logo:hover {
      opacity: .85;
    }

    .logo-mark {
      width: 26px;
      height: 26px;
      background: var(--acid);
      color: #000;
      display: grid;
      place-items: center;
      font-family: "JetBrains Mono", monospace;
      font-size: 12px;
      font-weight: 600;
      border-radius: 4px;
      box-shadow: 0 0 18px rgba(200, 245, 66, .35);
    }

    .nav-links {
      display: flex;
      gap: 28px;
      font-size: 13px;
      color: var(--muted);
    }

    .nav-links a {
      transition: color .35s, transform .35s var(--ease);
      cursor: pointer;
      position: relative;
      display: inline-block;
    }

    .nav-links a::after {
      content: "";
      position: absolute;
      left: 0;
      bottom: -4px;
      width: 0;
      height: 1px;
      background: var(--acid);
      transition: width .35s var(--ease);
    }

    .nav-links a:hover {
      color: var(--text);
      transform: translateY(-2px);
    }

    .nav-links a:hover::after {
      width: 100%;
    }

    .nav-actions {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .nav-login {
      padding: 8px 16px;
      border-radius: 8px;
      background: transparent;
      border: 1px solid rgba(216, 189, 155, .25);
      color: var(--beige);
      font-size: 11px;
      font-weight: 600;
      font-family: "JetBrains Mono", monospace;
      text-transform: uppercase;
      letter-spacing: .08em;
      transition: all .35s var(--ease);
      position: relative;
      overflow: hidden;
    }

    .nav-login::before {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(90deg, transparent, rgba(216, 189, 155, .12), transparent);
      transform: translateX(-100%);
      transition: transform .6s var(--ease);
    }

    .nav-login:hover {
      border-color: var(--beige);
      color: #fff0d8;
      box-shadow: 0 0 24px rgba(216, 189, 155, .2);
      transform: translateY(-2px);
    }

    .nav-login:hover::before {
      transform: translateX(100%);
    }

    .login-overlay {
      position: fixed;
      inset: 0;
      z-index: 300;
      background: rgba(0, 0, 0, .92);
      backdrop-filter: blur(14px);
      display: none;
      align-items: center;
      justify-content: center;
      padding: 20px;
      opacity: 0;
      transition: opacity .4s ease;
    }

    .login-overlay.open {
      display: flex;
    }

    .login-overlay.fade {
      opacity: 1;
    }

    .login-modal {
      background: linear-gradient(180deg, var(--surface), rgba(216, 189, 155, .04));
      border: 1px solid var(--line);
      border-radius: 20px;
      width: min(420px, 100%);
      padding: 36px;
      position: relative;
      transform: translateY(20px);
      opacity: 0;
      transition: all .55s var(--ease);
      box-shadow: 0 50px 120px rgba(0, 0, 0, .7), 0 0 0 1px rgba(216, 189, 155, .08);
    }

    .login-overlay.fade .login-modal {
      transform: translateY(0);
      opacity: 1;
    }

    .login-close {
      position: absolute;
      top: 18px;
      right: 18px;
      width: 34px;
      height: 34px;
      border-radius: 8px;
      background: rgba(255, 255, 255, .04);
      border: 1px solid var(--line);
      color: var(--muted);
      font-size: 14px;
      display: grid;
      place-items: center;
      transition: all .35s var(--ease);
      cursor: pointer;
    }

    .login-close:hover {
      background: rgba(216, 189, 155, .12);
      color: var(--text);
      transform: rotate(90deg);
      border-color: rgba(216, 189, 155, .3);
    }

    .login-brand {
      text-align: center;
      margin-bottom: 28px;
    }

    .login-brand .logo-mark {
      margin: 0 auto 14px;
      width: 44px;
      height: 44px;
      font-size: 18px;
      border-radius: 10px;
      box-shadow: 0 0 30px rgba(200, 245, 66, .25);
    }

    .login-brand h2 {
      font-size: 22px;
      font-weight: 700;
      letter-spacing: -.03em;
      margin-bottom: 6px;
    }

    .login-brand p {
      color: var(--muted);
      font-size: 12px;
    }

    .login-field {
      margin-bottom: 16px;
    }

    .login-field label {
      display: block;
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      text-transform: uppercase;
      letter-spacing: .12em;
      color: var(--muted);
      margin-bottom: 8px;
    }

    .login-field input {
      width: 100%;
      padding: 13px 15px;
      border-radius: 10px;
      border: 1px solid var(--line);
      background: var(--bg);
      color: var(--text);
      font-size: 14px;
      font-family: inherit;
      transition: all .35s var(--ease);
      outline: none;
    }

    .login-field input:focus {
      border-color: var(--beige);
      box-shadow: 0 0 0 3px rgba(216, 189, 155, .1), 0 0 22px rgba(216, 189, 155, .12);
      background: var(--surface);
    }

    .login-field input::placeholder {
      color: var(--dim);
    }

    .login-btn {
      width: 100%;
      padding: 14px;
      border-radius: 10px;
      border: none;
      background: var(--acid);
      color: #000;
      font-weight: 700;
      font-size: 13px;
      margin-top: 8px;
      transition: all .35s var(--ease);
      position: relative;
      overflow: hidden;
    }

    .login-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 12px 36px rgba(216, 189, 155, .32);
      background: #e6cfaf;
      letter-spacing: .02em;
    }

    .login-btn:disabled {
      opacity: .6;
      cursor: wait;
      transform: none;
    }

    .login-error {
      color: var(--red);
      font-size: 12px;
      text-align: center;
      margin-top: 14px;
      min-height: 18px;
      font-family: "JetBrains Mono", monospace;
    }

    .login-hint {
      text-align: center;
      margin-top: 18px;
      padding-top: 18px;
      border-top: 1px solid var(--line);
      color: var(--dim);
      font-size: 10px;
      font-family: "JetBrains Mono", monospace;
    }

    .login-hint span {
      color: var(--beige);
    }

    @media(max-width: 640px) {
      .nav-login {
        padding: 7px 12px;
        font-size: 9px;
      }
      .login-modal {
        padding: 28px 22px;
      }
    }

    .nav-status {
      display: flex;
      align-items: center;
      gap: 8px;
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      color: #08dd1a;
      border: 1px solid rgba(216, 189, 155, .16);
      padding: 6px 12px;
      border-radius: 99px;
      background: var(--acid-dim);
    }

    .nav-dot {
      width: 5px;
      height: 5px;
      border-radius: 50%;
      background: var(--acid);
      animation: pulse 2.2s infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: .25; }
    }

    .hero {
      min-height: 100dvh;
      display: flex;
      align-items: center;
      position: relative;
      padding: 120px 0 60px;
      overflow: hidden;
      perspective: 1200px;
    }

    .hero::before {
      content: "";
      position: absolute;
      width: 1100px;
      height: 820px;
      top: -460px;
      left: 50%;
      transform: translateX(-50%);
      background: radial-gradient(ellipse, rgba(216, 189, 155, .22), rgba(176, 141, 103, .1) 38%, transparent 72%);
      filter: blur(24px);
      pointer-events: none;
      animation: heroGlow 8s ease-in-out infinite;
    }

    @keyframes heroGlow {
      0%, 100% { opacity: .85; }
      50% { opacity: 1; }
    }

    .hero::after {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(180deg, rgba(216, 189, 155, .1), transparent 28%);
      pointer-events: none;
    }

    .hero-grid {
      position: absolute;
      inset: 0;
      opacity: .25;
      background-image: linear-gradient(var(--line-soft) 1px, transparent 1px), linear-gradient(90deg, var(--line-soft) 1px, transparent 1px);
      background-size: 64px 64px;
      mask-image: radial-gradient(ellipse 75% 60% at 50% 40%, black, transparent);
      pointer-events: none;
      animation: gridPulse 12s ease-in-out infinite;
    }

    @keyframes gridPulse {
      0%, 100% { opacity: .22; }
      50% { opacity: .3; }
    }

    .hero-inner {
      position: relative;
      display: grid;
      grid-template-columns: 1fr 400px;
      gap: 64px;
      align-items: center;
      width: min(var(--max), calc(100% - 40px));
      margin: auto;
      transform-style: preserve-3d;
      transition: transform .3s var(--ease);
    }

    .hero h1 {
      font-size: clamp(48px, 7vw, 88px);
      line-height: .95;
      letter-spacing: -.05em;
      font-weight: 700;
    }

    .hero h1 .hl {
      display: block;
      overflow: hidden;
    }

    .hero h1 .hl span {
      display: block;
      transform: translateY(110%);
      animation: riseUp 1.1s var(--ease) forwards;
    }

    .hero h1 .hl:nth-child(2) span { animation-delay: .16s; }
    .hero h1 .hl:nth-child(3) span { animation-delay: .32s; }

    @keyframes riseUp {
      to { transform: none; }
    }

    .hero h1 em {
      font-style: normal;
      color: #c4ae90;
    }

    .hero-sub {
      margin-top: 22px;
      color: var(--muted);
      font-size: 15px;
      line-height: 1.7;
      max-width: 480px;
      opacity: 0;
      animation: fadeUp 1s var(--ease) .6s forwards;
    }

    .hero-sub b {
      color: var(--text);
      font-weight: 600;
    }

    .hero-ctas {
      display: flex;
      gap: 10px;
      margin-top: 32px;
      opacity: 0;
      animation: fadeUp 1s var(--ease) .8s forwards;
    }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(22px); }
      to { opacity: 1; transform: none; }
    }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      min-height: 46px;
      padding: 0 22px;
      border-radius: var(--radius);
      font-size: 13px;
      font-weight: 600;
      transition: all .25s var(--ease);
      border: none;
    }

    .btn-primary {
      background: var(--acid);
      color: #0a0c05;
      transition: transform .35s var(--ease), box-shadow .35s var(--ease), background .35s, letter-spacing .35s var(--ease);
    }

    .btn-primary:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: 0 16px 40px rgba(216, 189, 155, .38);
      background: #e6cfaf;
      letter-spacing: .02em;
    }

    .btn-ghost {
      background: transparent;
      color: var(--text);
      border: 1px solid var(--line);
      transition: transform .35s var(--ease), background .35s, border-color .35s, box-shadow .35s;
    }

    .btn-ghost:hover {
      border-color: #3a4247;
      background: var(--surface);
      transform: translateY(-4px) scale(1.02);
      box-shadow: 0 10px 32px rgba(0, 0, 0, .35);
    }

    .term {
      background: linear-gradient(180deg, var(--surface), rgba(216, 189, 155, .04));
      border: 1px solid var(--line);
      border-radius: var(--radius);
      overflow: hidden;
      box-shadow: 0 24px 60px rgba(0, 0, 0, .5);
      opacity: 0;
      animation: fadeUp 1.1s var(--ease) .7s forwards;
      transition: transform .55s var(--ease), box-shadow .55s var(--ease), border-color .35s;
    }

    .term:hover {
      transform: translateY(-6px) scale(1.01);
      box-shadow: 0 32px 70px rgba(0, 0, 0, .55);
      border-color: #2a3136;
    }

    .term-bar {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 16px;
      border-bottom: 1px solid var(--line);
      background: linear-gradient(90deg, var(--surface-2), rgba(216, 189, 155, .04));
    }

    .term-dot {
      width: 10px;
      height: 10px;
      border-radius: 50%;
      transition: transform .3s var(--ease);
    }

    .term-bar:hover .term-dot:nth-child(1) { transform: scale(1.2); }
    .term-bar:hover .term-dot:nth-child(2) { transform: scale(1.2); transition-delay: .05s; }
    .term-bar:hover .term-dot:nth-child(3) { transform: scale(1.2); transition-delay: .1s; }

    .term-title {
      margin-left: auto;
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      color: var(--dim);
    }

    .term-body {
      background: var(--bg);
      color: var(--text);
      padding: 18px 20px;
      font-family: "JetBrains Mono", monospace;
      font-size: 12.5px;
      line-height: 1.85;
      font-variant-ligatures: none;
      text-rendering: optimizeLegibility;
      min-height: 195px;
    }

    .tl {
      opacity: 0;
      transform: translateY(8px);
      white-space: nowrap;
      overflow: hidden;
      transition: opacity .55s var(--ease), transform .55s var(--ease);
    }

    .tl.visible {
      opacity: 1;
      transform: translateY(0);
    }

    .t-1 {
      display: flex;
      align-items: center;
    }

    .t-1 .type-text {
      display: inline-block;
      width: 0;
      overflow: hidden;
      white-space: nowrap;
      border-right: 2px solid var(--text);
      animation: typing 2s steps(20, end) forwards, blink-caret .8s step-end infinite, hide-cursor .25s forwards 2.2s;
    }

    .t-2 { transition-delay: 2.6s; }
    .t-3 { transition-delay: 3.3s; }
    .t-4 { transition-delay: 4.0s; }
    .t-5 { transition-delay: 4.7s; }
    .t-6 { transition-delay: 5.4s; }

    .t-2.visible,
    .t-3.visible,
    .t-4.visible,
    .t-5.visible {
      animation: softGlow 3s ease-in-out infinite;
    }

    .t-6.visible .cursor {
      display: inline-block;
      width: 8px;
      height: 14px;
      background: var(--text);
      vertical-align: middle;
      margin-left: 4px;
      animation: blink 1s infinite, softGlow 3s ease-in-out infinite;
    }

    @keyframes typing {
      from { width: 0; }
      to { width: 20ch; }
    }

    @keyframes blink-caret {
      0%, 100% { border-color: transparent; }
      50% { border-color: var(--text); }
    }

    @keyframes hide-cursor {
      to { border-right-color: transparent; }
    }

    @keyframes softGlow {
      0%, 100% { text-shadow: 0 0 0 transparent; opacity: 1; }
      50% { text-shadow: 0 0 12px rgba(216, 189, 155, .35); opacity: .95; }
    }

    @keyframes slideIn {
      from { opacity: 0; clip-path: inset(0 100% 0 0); transform: translateX(-12px); filter: blur(2px); }
      40% { opacity: .7; filter: blur(0); }
      to { opacity: 1; clip-path: inset(0 0 0 0); transform: translateX(0); filter: blur(0); }
    }

    @keyframes popIn {
      to { opacity: 1; }
    }

    @keyframes blink {
      0%, 100% { opacity: 1; }
      50% { opacity: 0; }
    }

    .w { color: var(--w); }
    .plus { color: var(--plus); }
    .v { color: var(--v); }
    .wr { color: var(--wr); }
    .c-eac { color: var(--eac); }
    .c-be { color: var(--be); }
    .c-success { color: var(--success); }
    .c-warn { color: var(--warn); }
    .g { color: #626262; }
    .w { color: #fff; }

    .ticker-wrap {
      border-top: 1px solid var(--line);
      border-bottom: 1px solid var(--line);
      background: linear-gradient(90deg, rgba(216, 189, 155, .08), var(--surface) 15%, var(--surface) 85%, rgba(216, 189, 155, .08));
      overflow: hidden;
      padding: 12px 0;
      position: relative;
    }

    .ticker-wrap:hover {
      background: linear-gradient(90deg, rgba(216, 189, 155, .12), var(--surface) 15%, var(--surface) 85%, rgba(216, 189, 155, .12));
    }

    .ticker-wrap::before,
    .ticker-wrap::after {
      content: "";
      position: absolute;
      top: 0;
      bottom: 0;
      width: 80px;
      z-index: 2;
      pointer-events: none;
    }

    .ticker-wrap::before {
      left: 0;
      background: linear-gradient(90deg, var(--bg), transparent);
      transition: width .5s var(--ease);
    }

    .ticker-wrap::after {
      right: 0;
      background: linear-gradient(-90deg, var(--bg), transparent);
      transition: width .5s var(--ease);
    }

    .ticker-wrap:hover::before,
    .ticker-wrap:hover::after {
      width: 120px;
    }

    .ticker {
      display: flex;
      gap: 52px;
      white-space: nowrap;
      animation: scroll 45s linear infinite;
      width: max-content;
    }

    .ticker span {
      font-family: "JetBrains Mono", monospace;
      font-size: 11px;
      color: var(--muted);
      display: flex;
      align-items: center;
      gap: 10px;
      position: relative;
      transition: color .3s, transform .3s var(--ease), text-shadow .3s;
      animation: float 4s ease-in-out infinite;
    }

    .ticker span:nth-child(2n) { animation-delay: .5s; }
    .ticker span:nth-child(3n) { animation-delay: 1s; }

    .ticker span:hover {
      color: #fff0d8;
      transform: translateY(-2px);
      text-shadow: 0 0 20px rgba(216, 189, 155, .45);
      animation-play-state: paused;
    }

    .ticker-wrap:hover .ticker {
      animation-play-state: paused;
    }

    .ticker span::before {
      content: ">";
      color: #c4ae90;
      font-size: 9px;
      transition: transform .35s var(--ease);
    }

    .ticker span:hover::before {
      transform: translateX(3px);
    }

    @keyframes scroll {
      to { transform: translateX(-50%); }
    }

    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-6px); }
    }

    section {
      padding: 80px 0;
    }

    section:first-of-type {
      padding-top: 60px;
    }

    #products {
      padding: 60px 0 70px;
    }

    .sec-head {
      margin-bottom: 42px;
    }

    .sec-kicker {
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      color: #c4ae90;
      text-transform: uppercase;
      letter-spacing: .2em;
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
      transition: letter-spacing .45s var(--ease);
    }

    .sec-head:hover .sec-kicker {
      letter-spacing: .32em;
    }

    .sec-kicker::before {
      content: "";
      width: 24px;
      height: 1px;
      background: var(--acid);
    }

    .sec-title {
      font-size: clamp(32px, 4.5vw, 48px);
      letter-spacing: -.04em;
      font-weight: 700;
      line-height: 1.05;
      transition: color .35s;
    }

    .sec-head:hover .sec-title {
      color: #fff0d8;
    }

    .sec-desc {
      color: var(--muted);
      font-size: 14px;
      line-height: 1.7;
      margin-top: 14px;
      max-width: 440px;
      transition: transform .45s var(--ease);
    }

    .sec-head:hover .sec-desc {
      transform: translateX(8px);
    }

    .showcase {
      position: relative;
      border-top: 1px solid var(--line);
      border-bottom: 1px solid var(--line);
      overflow: hidden;
      transition: border-color .45s;
    }

    .showcase:hover {
      border-top-color: #2a3136;
      border-bottom-color: #2a3136;
    }

    .showcase-img {
      width: 100%;
      height: 420px;
      object-fit: cover;
      opacity: .65;
      filter: saturate(.9) contrast(1.05);
      transform: scale(1.08);
      transition: transform 12s var(--ease);
    }

    .showcase.in .showcase-img {
      transform: scale(1);
    }

    .showcase:hover .showcase-img {
      transform: scale(1.02);
    }

    .showcase-overlay {
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      background: linear-gradient(90deg, rgba(7, 8, 9, .94) 0%, rgba(7, 8, 9, .45) 60%, rgba(7, 8, 9, .85) 100%);
    }

    .showcase-inner {
      width: min(var(--max), calc(100% - 40px));
      margin: auto;
    }

    .showcase-inner h3 {
      font-size: clamp(26px, 3.5vw, 40px);
      letter-spacing: -.04em;
      font-weight: 700;
      max-width: 520px;
      line-height: 1.1;
      transition: transform .6s var(--ease);
    }

    .showcase:hover .showcase-inner h3 {
      transform: translateX(12px);
    }

    .showcase-inner h3 em {
      font-style: normal;
      color: #c4ae90;
    }

    .showcase-inner p {
      color: var(--muted);
      font-size: 14px;
      margin-top: 14px;
      max-width: 440px;
      line-height: 1.7;
      transition: transform .6s var(--ease) .08s, opacity .6s;
    }

    .showcase:hover .showcase-inner p {
      transform: translateX(12px);
      opacity: .9;
    }

    .pgrid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 16px;
      align-items: stretch;
      max-width: 840px;
      margin: 0 auto;
    }

    .pcard {
      position: relative;
      background: linear-gradient(145deg, rgba(216, 189, 155, .055), var(--surface) 28%);
      border: 1px solid var(--line);
      border-radius: 14px;
      display: flex;
      flex-direction: column;
      min-width: 0;
      transition: transform .7s var(--ease), border-color .4s, box-shadow .7s;
      overflow: visible;
      margin: 0 auto;
    }

    .pcard::after {
      content: "";
      position: absolute;
      inset: 0;
      border-radius: inherit;
      border: 1px solid transparent;
      background: linear-gradient(135deg, rgba(216, 189, 155, .4), transparent 35%) border-box;
      mask: linear-gradient(#000 0 0) padding-box, linear-gradient(#000 0 0);
      mask-composite: exclude;
      opacity: 0;
      transition: opacity .35s;
      pointer-events: none;
    }

    .pcard:hover::after {
      opacity: 1;
    }

    .pcard::before {
      content: "";
      position: absolute;
      inset: 0;
      background: radial-gradient(400px circle at var(--mx, 50%) var(--my, 50%), rgba(216, 189, 155, .12), transparent 50%);
      opacity: 0;
      transition: opacity .4s;
      pointer-events: none;
      z-index: 2;
      border-radius: 14px;
    }

    .pcard:hover::before {
      opacity: 1;
    }

    .pcard:hover {
      transform: translateY(-8px) scale(1.015);
      border-color: #3a4247;
      box-shadow: 0 26px 65px rgba(0, 0, 0, .58), 0 0 0 1px rgba(216, 189, 155, .12);
    }

    .pcard-imgwrap {
      aspect-ratio: 16/9;
      overflow: hidden;
      border-bottom: 1px solid var(--line);
      position: relative;
      border-radius: 14px 14px 0 0;
      display: flex;
      align-items: center;
      justify-content: center;
      background: transparent;
    }

    .pcard-imgwrap::after {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(180deg, transparent 55%, rgba(12, 14, 16, .92) 100%);
      pointer-events: none;
    }

    .pcard-img {
      width: 100%;
      height: 100%;
      object-fit: contain;
      padding: 10px;
      transition: transform .9s var(--ease), filter .7s;
    }

    .pcard:hover .pcard-img {
      transform: scale(1.05);
      filter: saturate(1.05) brightness(1);
    }

    .pcard-body {
      padding: 12px 14px 14px;
      display: flex;
      flex-direction: column;
      flex: 1;
      justify-content: space-between;
    }

    .pcard-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 8px;
    }

    .pcard-icon {
      width: 40px;
      height: 40px;
      border-radius: var(--radius);
      background: var(--acid-dim);
      border: 1px solid rgba(216, 189, 155, .12);
      display: grid;
      place-items: center;
      font-size: 18px;
      transition: transform .4s var(--ease);
    }

    .pcard:hover .pcard-icon {
      transform: rotate(-12deg) scale(1.14);
    }

    .pbadge {
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      padding: 4px 10px;
      border-radius: 99px;
      letter-spacing: .1em;
      text-transform: uppercase;
      font-weight: 600;
      transition: transform .35s var(--ease), box-shadow .35s;
    }

    .pcard:hover .pbadge {
      transform: translateY(-2px);
      box-shadow: 0 4px 14px rgba(216, 189, 155, .15);
    }

    .b-hot {
      background: rgba(255, 77, 109, .08);
      color: var(--red);
      border: 1px solid rgba(240, 22, 22, 0.2);
    }

    .b-pop {
      background: var(--acid-dim);
      color: #fbfbfb;
      border: 1px solid rgba(216, 189, 155, .18);
    }

    .pcard-label {
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      color: #c4ae90;
      text-transform: uppercase;
      letter-spacing: .12em;
      margin-bottom: 6px;
      transition: letter-spacing .35s var(--ease);
    }

    .pcard:hover .pcard-label {
      letter-spacing: .18em;
    }

    .pcard-title {
      font-size: 13px;
      font-weight: 700;
      letter-spacing: -.02em;
      margin-bottom: 4px;
      transition: color .4s, transform .45s var(--ease);
    }

    .pcard:hover .pcard-title {
      color: #fff0d8;
      transform: translateY(-2px);
    }

    .pcard-desc {
      color: var(--muted);
      font-size: 10.5px;
      line-height: 1.5;
      margin-bottom: 10px;
      min-height: 34px;
    }

    .pfeats {
      list-style: none;
      display: grid;
      gap: 2px;
      margin-bottom: 10px;
      min-height: 58px;
    }

    .pfeats li {
      color: #9aa2a7;
      font-size: 9.5px;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: color .35s, transform .35s var(--ease);
    }

    .pcard:hover .pfeats li {
      color: #b8c0c4;
      transform: translateX(3px);
    }

    .pfeats li::before {
      content: "";
      width: 12px;
      height: 12px;
      border-radius: 3px;
      flex-shrink: 0;
      background: var(--acid-dim);
      border: 1px solid rgba(216, 189, 155, .2);
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23d8bd9b' stroke-width='3'%3E%3Cpath d='M5 13l4 4L19 7'/%3E%3C/svg%3E");
      background-size: 8px;
      background-position: center;
      background-repeat: no-repeat;
      transition: transform .35s var(--ease);
    }

    .pcard:hover .pfeats li::before {
      transform: scale(1.15);
    }

    .pcard-bottom {
      margin-top: 0;
      padding-top: 12px;
      border-top: 1px solid var(--line);
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 10px;
    }

    .price {
      font-size: 16px;
      font-weight: 700;
      letter-spacing: -.02em;
      transition: transform .35s var(--ease);
    }

    .pcard:hover .price {
      transform: translateY(-2px);
    }

    .price-old {
      font-size: 11px;
      color: var(--dim);
      text-decoration: line-through;
      font-family: "JetBrains Mono", monospace;
      margin-left: 4px;
    }

    .price-note {
      font-size: 9px;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
      text-transform: uppercase;
      letter-spacing: .1em;
      margin-top: 2px;
    }

    .qty-stepper {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 4px;
      background: var(--bg);
      margin-bottom: 10px;
    }

    .qty-stepper button {
      width: 28px;
      height: 28px;
      border-radius: 6px;
      border: none;
      background: var(--surface-2);
      color: var(--text);
      font-size: 16px;
      display: grid;
      place-items: center;
      transition: all .25s var(--ease);
    }

    .qty-stepper button:hover {
      background: var(--acid);
      color: #000;
    }

    .qty-stepper .qty-value {
      min-width: 30px;
      text-align: center;
      font-family: "JetBrains Mono", monospace;
      font-size: 13px;
      font-weight: 600;
    }

    .source-note {
      display: none;
      font-size: 11px;
      color: var(--muted);
      margin-bottom: 10px;
      padding: 8px 10px;
      border: 1px dashed rgba(216, 189, 155, .25);
      border-radius: 8px;
    }

    .source-only .license-opts {
      display: none !important;
    }

    .source-only .source-note {
      display: block;
    }

    .bundle-select {
      margin: 0 0 10px;
      position: relative;
      z-index: 200;
    }

    .bundle-select label {
      display: block;
      margin-bottom: 5px;
      color: var(--muted);
      font: 9px "JetBrains Mono", monospace;
      text-transform: uppercase;
      letter-spacing: .1em;
    }

    .dropdown-trigger {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      padding: 8px 10px;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--bg);
      cursor: pointer;
      transition: all .35s var(--ease);
    }

    .dropdown-trigger:hover {
      border-color: #3a4247;
      box-shadow: 0 10px 30px rgba(0, 0, 0, .25);
    }

    .bundle-select.open .dropdown-trigger {
      border-color: var(--beige);
      box-shadow: 0 0 22px rgba(216, 189, 155, .15);
    }

    .dropdown-current {
      font-size: 12px;
      font-weight: 600;
      color: var(--text);
    }

    .dropdown-arrow {
      font-size: 9px;
      color: var(--muted);
      transition: transform .35s var(--ease);
    }

    .bundle-select.open .dropdown-arrow {
      transform: rotate(180deg);
    }

    .dropdown-menu {
      position: absolute;
      top: calc(100% + 6px);
      left: 0;
      right: 0;
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: 10px;
      padding: 6px;
      opacity: 0;
      visibility: hidden;
      transform: translateY(-8px) scale(.98);
      transform-origin: top center;
      transition: all .35s var(--ease);
      box-shadow: 0 20px 50px rgba(0, 0, 0, .45);
      z-index: 300;
    }

    .bundle-select.open .dropdown-menu {
      opacity: 1;
      visibility: visible;
      transform: translateY(0) scale(1);
    }

    .dropdown-option {
      padding: 8px 10px;
      border-radius: 6px;
      font-size: 10.5px;
      color: var(--muted);
      cursor: pointer;
      transition: all .2s var(--ease);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .dropdown-option:hover {
      background: rgba(216, 189, 155, .1);
      color: var(--text);
      transform: translateX(4px);
    }

    .dropdown-option.selected {
      background: rgba(216, 189, 155, .14);
      color: var(--text);
    }

    .dropdown-option .save {
      color: var(--gold);
      font-size: 10px;
      font-family: "JetBrains Mono", monospace;
    }

    .drv-toggle {
      display: flex;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--bg);
      padding: 3px;
      margin-bottom: 10px;
      gap: 3px;
      transition: all .35s var(--ease);
    }

    .drv-toggle:hover {
      border-color: #2a3136;
      box-shadow: 0 10px 30px rgba(0, 0, 0, .25);
    }

    .drv-toggle button {
      flex: 1;
      padding: 9px;
      border: none;
      background: transparent;
      color: var(--muted);
      font-size: 11px;
      font-weight: 600;
      border-radius: 6px;
      font-family: "JetBrains Mono", monospace;
      transition: all .35s var(--ease);
    }

    .drv-toggle button.active {
      background: var(--acid);
      color: #000;
    }

    .drv-toggle button:not(.active):hover {
      color: var(--text);
      background: rgba(216, 189, 155, .05);
    }

    .ppage {
      display: none;
      padding: 80px 0 60px;
      min-height: 100dvh;
    }

    .ppage.active {
      display: block;
      animation: pageIn .5s var(--ease);
    }

    @keyframes pageIn {
      from { opacity: 0; transform: translateY(28px); }
      to { opacity: 1; transform: none; }
    }

    .ppage-hero {
      display: grid;
      grid-template-columns: 1fr 320px;
      gap: 36px;
      align-items: start;
      margin-bottom: 40px;
    }

    .ppage-bannerwrap {
      max-height: 210px;
      border-radius: var(--radius);
      border: none;
      margin-bottom: 20px;
      overflow: hidden;
      position: relative;
      transition: transform .5s var(--ease);
      background: transparent;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0;
    }

    .ppage-bannerwrap:hover {
      transform: translateY(-4px);
    }

    .ppage-bannerwrap::after {
      display: none;
    }

    .ppage-banner {
      max-width: 100%;
      max-height: 190px;
      width: auto;
      height: auto;
      object-fit: contain;
      background: transparent;
      transition: transform .5s var(--ease);
      filter: drop-shadow(0 10px 26px rgba(0, 0, 0, .5));
    }

    .ppage-bannerwrap:hover .ppage-banner {
      transform: scale(1.04);
    }

    .ppage-badge {
      display: inline-block;
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      padding: 6px 14px;
      border-radius: 99px;
      margin-bottom: 16px;
      background: rgba(12, 14, 16, .95);
      color: var(--text);
      border: 1px solid rgba(216, 189, 155, .45);
      text-transform: uppercase;
      letter-spacing: .12em;
      font-weight: 600;
      box-shadow: 0 4px 20px rgba(0, 0, 0, .45), 0 0 0 1px rgba(216, 189, 155, .12);
      position: relative;
      z-index: 2;
    }

    .ppage h1 {
      font-size: clamp(28px, 3.8vw, 42px);
      letter-spacing: -.04em;
      font-weight: 700;
      line-height: 1;
      margin-bottom: 16px;
    }

    .ppage-sub {
      color: var(--muted);
      font-size: 13px;
      line-height: 1.7;
      max-width: 520px;
      margin-bottom: 22px;
    }

    .ppage-meta {
      display: flex;
      gap: 28px;
      flex-wrap: wrap;
    }

    .ppm-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .ppm-val {
      font-size: 18px;
      font-weight: 700;
    }

    .ppm-val em {
      font-style: normal;
      color: #c4ae90;
    }

    .ppm-lbl {
      font-size: 9px;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
      text-transform: uppercase;
      letter-spacing: .1em;
    }

    .pp-feats {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 12px;
      margin-bottom: 40px;
    }

    .pp-feat {
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      padding: 14px;
      transition: all .4s var(--ease);
    }

    .pp-feat:hover {
      border-color: #2a3136;
      background: linear-gradient(145deg, var(--surface-2), rgba(216, 189, 155, .06));
      transform: translateY(-6px);
      box-shadow: 0 18px 45px rgba(0, 0, 0, .4);
    }

    .pp-feat-icon {
      width: 32px;
      height: 32px;
      border-radius: 8px;
      background: var(--acid-dim);
      border: 1px solid rgba(216, 189, 155, .1);
      display: grid;
      place-items: center;
      font-size: 13px;
      margin-bottom: 10px;
      transition: transform .4s var(--ease);
    }

    .pp-feat:hover .pp-feat-icon {
      transform: scale(1.2) rotate(-8deg);
    }

    .pp-feat h4 {
      font-size: 12px;
      font-weight: 600;
      margin-bottom: 5px;
      transition: color .35s;
    }

    .pp-feat:hover h4 {
      color: #fff0d8;
    }

    .pp-feat p {
      color: var(--muted);
      font-size: 10.5px;
      line-height: 1.65;
      transition: opacity .35s;
    }

    .pp-feat:hover p {
      opacity: .85;
    }

    .co-side {
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: var(--radius);
      padding: 18px;
      position: sticky;
      top: 80px;
      transition: border-color .35s, box-shadow .35s, transform .35s var(--ease);
    }

    .co-side:hover {
      border-color: #2a3136;
      box-shadow: 0 22px 65px rgba(0, 0, 0, .5);
      transform: translateY(-3px);
    }

    .co-price-row {
      display: flex;
      align-items: baseline;
      gap: 8px;
      margin-bottom: 4px;
    }

    .co-price {
      font-size: 26px;
      font-weight: 700;
      letter-spacing: -.04em;
      transition: transform .35s var(--ease);
    }

    .co-price-period {
      font-size: 13px;
      color: var(--muted);
      font-weight: 500;
      letter-spacing: 0;
      margin-left: 2px;
    }

    .co-side:hover .co-price {
      transform: translateY(-2px);
    }

    .co-old {
      font-size: 13px;
      color: var(--dim);
      text-decoration: line-through;
      font-family: "JetBrains Mono", monospace;
    }

    .co-note {
      font-size: 9.5px;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
      margin-bottom: 14px;
    }

    .co-label {
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: .12em;
      margin-bottom: 10px;
    }

    .co-opts {
      display: grid;
      gap: 6px;
      margin-bottom: 16px;
    }

    .co-opt {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 8px 10px;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--bg);
      cursor: pointer;
      transition: all .35s var(--ease);
      position: relative;
      overflow: hidden;
    }

    .co-opt:hover {
      border-color: #3a4247;
      transform: translateX(8px) scale(1.01);
      background: var(--surface-2);
    }

    .co-opt::after {
      content: "";
      position: absolute;
      inset: 0;
      background: linear-gradient(90deg, transparent, rgba(216, 189, 155, .08), transparent);
      transform: translateX(-100%);
      transition: transform .6s var(--ease);
    }

    .co-opt:hover::after {
      transform: translateX(100%);
    }

    .co-opt.selected {
      border-color: #c4ae90;
      background: linear-gradient(90deg, rgba(216, 189, 155, .08), transparent);
    }

    .ci {
      width: 30px;
      height: 30px;
      border-radius: 7px;
      flex-shrink: 0;
      display: grid;
      place-items: center;
      font-weight: 700;
      font-size: 12px;
      font-family: "JetBrains Mono", monospace;
    }

    .ci-btc { background: rgba(247, 147, 26, .1); color: #f7931a; }
    .ci-eth { background: rgba(98, 126, 234, .1); color: #8a9eff; }
    .ci-ltc { background: rgba(52, 93, 157, .1); color: #a5b9d5; }
    .ci-usdt { background: rgba(38, 161, 123, .1); color: #4cd3a5; }

    .ci img {
      width: 30px;
      height: 30px;
      object-fit: cover;
      border-radius: 50%;
      vertical-align: middle;
    }

    .cn {
      font-size: 11px;
      font-weight: 600;
    }

    .cnet {
      font-size: 8px;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
    }

    .ccheck {
      margin-left: auto;
      width: 16px;
      height: 16px;
      border-radius: 50%;
      border: 2px solid var(--line);
      flex-shrink: 0;
      transition: all .35s var(--ease);
    }

    .co-opt.selected .ccheck {
      border-color: #c4ae90;
      background: var(--acid);
      box-shadow: 0 0 10px rgba(216, 189, 155, .4);
    }

    .co-btn {
      width: 100%;
      padding: 11px;
      border-radius: 10px;
      border: none;
      background: var(--acid);
      color: #000;
      font-weight: 700;
      font-size: 12px;
      transition: transform .35s var(--ease), box-shadow .35s var(--ease), background .35s, letter-spacing .35s var(--ease);
      margin-bottom: 10px;
      position: relative;
      overflow: hidden;
    }

    .co-btn:hover {
      transform: translateY(-3px);
      box-shadow: 0 10px 32px rgba(216, 189, 155, .28);
      background: #e6cfaf;
    }

    .co-btn:active {
      transform: translateY(0);
    }

    .co-meta {
      display: grid;
      gap: 4px;
    }

    .co-meta span {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 8.5px;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
    }

    .co-meta span::before {
      content: ">";
      color: #c4ae90;
      font-size: 9px;
    }

    .ver-toggle {
      display: flex;
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--bg);
      padding: 3px;
      margin-bottom: 14px;
      gap: 3px;
      transition: all .35s var(--ease);
    }

    .ver-toggle:hover {
      border-color: #2a3136;
      box-shadow: 0 10px 30px rgba(0, 0, 0, .25);
    }

    .ver-toggle button {
      flex: 1;
      padding: 8px;
      border: none;
      background: transparent;
      color: var(--muted);
      font-size: 11px;
      font-weight: 600;
      border-radius: 6px;
      font-family: "JetBrains Mono", monospace;
      transition: all .35s var(--ease);
    }

    .ver-toggle button.active {
      background: var(--acid);
      color: #000;
    }

    .ver-toggle button:not(.active):hover {
      color: var(--text);
      background: rgba(216, 189, 155, .05);
    }

    .badge {
      display: inline-block;
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: var(--acid);
      border: 1px solid var(--acid);
      padding: 4px 8px;
      border-radius: 4px;
      margin-top: 8px;
      font-weight: 600;
    }

    .price-container {
      display: flex;
      align-items: baseline;
      margin: 20px 0;
    }

    .currency {
      font-size: 24px;
      color: var(--muted);
      margin-right: 4px;
    }

    .amount {
      font-size: 64px;
      font-weight: 700;
      letter-spacing: -2px;
      line-height: 1;
    }

    .period {
      font-size: 16px;
      color: var(--muted);
      margin-left: 8px;
      font-family: "JetBrains Mono", monospace;
    }

    .muted {
      color: var(--muted);
      font-size: 13px;
    }

    .cta-btn {
      width: 100%;
      padding: 14px;
      background: var(--acid);
      color: #000;
      border: none;
      border-radius: 8px;
      font-weight: 600;
      font-size: 15px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: transform 0.2s var(--ease), box-shadow 0.2s;
    }

    .cta-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 0 20px rgba(200, 245, 66, 0.4);
    }

    .arrow {
      transition: transform 0.2s;
    }

    .cta-btn:hover .arrow {
      transform: translateX(4px);
    }

    .strip {
      background: linear-gradient(180deg, rgba(216, 189, 155, .04), var(--surface) 12%, var(--surface) 88%, rgba(216, 189, 155, .04));
      border-top: 1px solid var(--line);
      border-bottom: 1px solid var(--line);
    }

    .strip-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
    }

    .strip-item {
      padding: 34px 28px;
      border-right: 1px solid var(--line);
      transition: transform .7s var(--ease), background .45s, box-shadow .7s, border-color .4s;
      position: relative;
      overflow: hidden;
    }

    .strip-item:last-child {
      border-right: none;
    }

    .strip-item:hover {
      background: linear-gradient(145deg, var(--surface-2), rgba(216, 189, 155, .1));
      transform: translateY(-8px);
      box-shadow: inset 0 1px 0 rgba(216, 189, 155, .25), 0 24px 60px rgba(0, 0, 0, .4);
      z-index: 2;
    }

    .strip-item::after {
      content: "";
      position: absolute;
      left: 32px;
      right: 32px;
      bottom: 0;
      height: 2px;
      background: var(--beige);
      transform: scaleX(0);
      transform-origin: left;
      transition: transform .55s var(--ease);
    }

    .strip-item:hover::after {
      transform: scaleX(1);
    }

    .strip-item:hover .strip-num {
      letter-spacing: .3em;
      color: #fff0d8;
    }

    .strip-num {
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      color: #c4ae90;
      margin-bottom: 14px;
      display: block;
      transition: letter-spacing .45s var(--ease), color .35s;
    }

    .strip-item h4 {
      font-size: 15px;
      font-weight: 600;
      margin-bottom: 8px;
      transition: color .35s;
    }

    .strip-item:hover h4 {
      color: #fff0d8;
    }

    .strip-item p {
      color: var(--muted);
      font-size: 12px;
      line-height: 1.65;
      transition: opacity .35s;
    }

    .strip-item:hover p {
      opacity: .85;
    }

    .faq-wrap {
      max-width: 760px;
    }

    .faq-item {
      border-bottom: 1px solid var(--line);
      transition: transform .55s var(--ease), background .4s, border-radius .4s, border-color .4s, border-left .4s;
      margin: 0 -12px;
      padding: 0 12px;
      border-radius: 12px;
      border-left: 2px solid transparent;
    }

    .faq-item:first-child {
      border-top: 1px solid var(--line);
    }

    .faq-item:hover {
      transform: translateX(6px);
      background: rgba(216, 189, 155, .04);
      border-left-color: var(--beige);
    }

    .faq-item.open {
      background: rgba(216, 189, 155, .06);
      border-left-color: var(--beige);
    }

    .faq-q {
      width: 100%;
      background: transparent;
      border: none;
      color: var(--text);
      padding: 18px 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 13px;
      font-weight: 600;
      text-align: left;
      gap: 14px;
      transition: color .3s, padding-left .35s var(--ease), background .35s;
      border-radius: 10px;
    }

    .faq-q:hover {
      color: #c4ae90;
      padding-left: 10px;
    }

    .faq-item.open .faq-q {
      color: #c4ae90;
    }

    .faq-icon {
      width: 26px;
      height: 26px;
      border-radius: 6px;
      flex-shrink: 0;
      border: 1px solid var(--line);
      display: grid;
      place-items: center;
      color: var(--muted);
      font-size: 15px;
      transition: all .35s var(--ease);
      font-weight: 400;
    }

    .faq-q:hover .faq-icon {
      border-color: #c4ae90;
      color: #c4ae90;
      transform: rotate(90deg) scale(1.15);
    }

    .faq-item.open .faq-icon {
      transform: rotate(45deg);
      border-color: #c4ae90;
      color: #c4ae90;
    }

    .faq-a {
      max-height: 0;
      overflow: hidden;
      opacity: 0;
      transition: max-height .5s var(--ease), padding .5s var(--ease), padding-left .5s var(--ease), opacity .4s var(--ease);
    }

    .faq-item.open .faq-a {
      max-height: 200px;
      padding-bottom: 18px;
      padding-left: 6px;
      opacity: 1;
    }

    .faq-a p {
      color: var(--muted);
      font-size: 12.5px;
      line-height: 1.75;
      max-width: 620px;
      transition: transform .45s var(--ease);
    }

    .faq-item.open:hover .faq-a p {
      transform: translateX(6px);
    }

    .back-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--muted);
      font-size: 13px;
      margin-bottom: 32px;
      transition: color .3s, gap .35s var(--ease), transform .35s var(--ease);
      background: none;
      border: none;
      padding: 0;
      cursor: pointer;
    }

    .back-btn:hover {
      color: #c4ae90;
      gap: 14px;
      transform: translateX(-6px);
    }

    .overlay {
      position: fixed;
      inset: 0;
      z-index: 200;
      background: rgba(0, 0, 0, .86);
      backdrop-filter: blur(10px);
      display: none;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    .overlay.open {
      display: flex;
      animation: fadeIn .45s ease;
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    .modal {
      background: linear-gradient(180deg, var(--surface), rgba(216, 189, 155, .04));
      border: 1px solid var(--line);
      border-radius: 18px;
      width: min(440px, 100%);
      position: relative;
      animation: slideUp .55s var(--ease);
      box-shadow: 0 40px 100px rgba(0, 0, 0, .65), 0 0 0 1px rgba(216, 189, 155, .08);
    }

    @keyframes slideUp {
      from { transform: translateY(24px); opacity: 0; }
      to { transform: translateY(0); opacity: 1; }
    }

    .modal-close {
      position: absolute;
      top: 16px;
      right: 16px;
      z-index: 10;
      width: 32px;
      height: 32px;
      border-radius: 8px;
      background: rgba(255, 255, 255, .04);
      border: 1px solid var(--line);
      color: var(--muted);
      font-size: 14px;
      display: grid;
      place-items: center;
      transition: all .35s var(--ease);
      cursor: pointer;
    }

    .modal-close:hover {
      background: rgba(216, 189, 155, .12);
      color: var(--text);
      transform: rotate(90deg);
      border-color: rgba(216, 189, 155, .3);
    }

    .pay-body {
      text-align: center;
      padding: 34px;
    }

    .pay-badge {
      display: inline-block;
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      padding: 5px 12px;
      border-radius: 99px;
      margin-bottom: 10px;
      background: var(--acid-dim);
      color: #c4ae90;
      border: 1px solid rgba(216, 189, 155, .15);
      text-transform: uppercase;
      letter-spacing: .12em;
    }

    .pay-amount {
      font-size: 40px;
      font-weight: 700;
      letter-spacing: -.04em;
      margin: 10px 0 4px;
    }

    .pay-name {
      color: var(--muted);
      font-size: 13px;
      margin-bottom: 22px;
    }

    .qr-box {
      width: 170px;
      height: 170px;
      margin: 0 auto 18px;
      border-radius: 14px;
      background: #fff;
      padding: 13px;
      display: grid;
      place-items: center;
    }

    .qr-box svg {
      width: 100%;
      height: 100%;
    }

    .pay-addr {
      background: var(--bg);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 11px 13px;
      font-family: "JetBrains Mono", monospace;
      font-size: 11px;
      color: var(--muted);
      word-break: break-all;
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
      justify-content: space-between;
      text-align: left;
    }

    .copy-btn {
      padding: 5px 10px;
      border-radius: 5px;
      border: 1px solid var(--line);
      background: transparent;
      color: var(--muted);
      font-size: 10px;
      font-family: "JetBrains Mono", monospace;
      cursor: pointer;
      transition: all .35s var(--ease);
      flex-shrink: 0;
    }

    .copy-btn:hover {
      background: rgba(216, 189, 155, .08);
      border-color: #c4ae90;
      color: #c4ae90;
    }

    .pay-timer {
      font-family: "JetBrains Mono", monospace;
      font-size: 11px;
      color: var(--gold);
      margin-bottom: 12px;
    }

    .pay-status {
      font-size: 12px;
      color: var(--muted);
    }

    .mock-note {
      margin-top: 16px;
      padding: 10px 14px;
      border: 1px dashed rgba(255, 209, 102, .35);
      border-radius: 8px;
      color: var(--gold);
      font-family: "JetBrains Mono", monospace;
      font-size: 10px;
      letter-spacing: .06em;
      text-transform: uppercase;
    }

    footer {
      border-top: 1px solid var(--line);
      padding: 48px 0 30px;
      background: linear-gradient(180deg, var(--surface), rgba(216, 189, 155, .03));
      position: relative;
      overflow: hidden;
    }

    footer::before {
      content: "";
      position: absolute;
      inset: 0;
      background: radial-gradient(ellipse at 50% 0%, rgba(216, 189, 155, .08), transparent 60%);
      pointer-events: none;
    }

    .foot-grid {
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 48px;
      margin-bottom: 40px;
      position: relative;
      z-index: 1;
    }

    #logoBtn {
      width: 130px;
      height: 42px;
      background-image: url('assets/Logo.png');
      background-size: contain;
      background-repeat: no-repeat;
      background-position: left center;
      cursor: pointer;
    }

    #footLogo {
      width: 130px;
      height: 42px;
      background-image: url('assets/Logo.png');
      background-size: contain;
      background-repeat: no-repeat;
      background-position: left center;
      cursor: pointer;
      transition: opacity .4s var(--ease), transform .4s var(--ease);
      animation: fadeUp 1s var(--ease) both;
    }

    #footLogo:hover {
      opacity: .85;
      transform: scale(1.05) translateY(-2px);
    }

    .foot-links {
      display: flex;
      gap: 40px;
    }

    .foot-col h5 {
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      color: var(--dim);
      text-transform: uppercase;
      letter-spacing: .14em;
      margin-bottom: 14px;
    }

    .foot-col a {
      display: block;
      color: var(--muted);
      font-size: 12px;
      margin-bottom: 9px;
      transition: color .35s var(--ease), transform .35s var(--ease), padding-left .35s var(--ease);
      cursor: pointer;
      padding-left: 0;
      opacity: .85;
    }

    .foot-col a:hover {
      color: #c4ae90;
      transform: translateX(6px);
      padding-left: 6px;
      opacity: 1;
    }

    .foot-bottom {
      border-top: 1px solid var(--line);
      padding-top: 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: var(--dim);
      font-family: "JetBrains Mono", monospace;
      font-size: 9px;
      text-transform: uppercase;
      letter-spacing: .1em;
      position: relative;
      z-index: 1;
      transition: color .4s;
    }

    footer:hover .foot-bottom {
      color: var(--muted);
    }

    @media(max-width: 900px) {
      .hero-inner { grid-template-columns: 1fr; gap: 40px; }
      .term { display: none; }
      .pgrid { grid-template-columns: repeat(2, 1fr); gap: 14px; max-width: 100%; }
      .pcard { max-width: none; }
      .ppage-hero { grid-template-columns: 1fr; gap: 32px; }
      .pp-feats { grid-template-columns: repeat(2, 1fr); }
      .ppage-bannerwrap { max-height: 200px; padding: 0; }
      .ppage-banner { max-height: 170px; }
      .strip-grid { grid-template-columns: repeat(2, 1fr); }
      .strip-item { border-bottom: 1px solid var(--line); }
      .co-side { position: static; max-width: 420px; margin: 0 auto; width: 100%; }
      .foot-grid { grid-template-columns: 1fr; }
      .showcase-img { height: 360px; }
      .top-blur { height: 90px; filter: blur(36px); }
    }

    @media(max-width: 640px) {
      .nav-links { display: none; }
      .hero-ctas .btn { flex: 1; }
      .pgrid { grid-template-columns: 1fr; max-width: 420px; }
      .strip-grid { grid-template-columns: 1fr; }
      .strip-item { border-right: none; }
      .foot-links { flex-wrap: wrap; gap: 24px; }
      .pcard-bottom { flex-direction: row; align-items: center; gap: 10px; }
      .pcard-body { padding: 12px 14px 14px; }
      .pp-feats { grid-template-columns: 1fr; }
      .ppage-bannerwrap { max-height: 160px; padding: 0; }
      .ppage-banner { max-height: 130px; }
      #logoBtn { width: 110px; height: 36px; }
      .top-blur { height: 70px; filter: blur(28px); }
    }

    @media(prefers-reduced-motion: reduce) {
      *, *::before, *::after { animation-duration: .01ms !important; animation-iteration-count: 1 !important; transition-duration: .01ms !important; }
      .hero-grid, .ticker span { animation: none !important; }
    }
  </style>
</head>
<body>
  <div class="top-blur"></div>
  <nav>
    <div class="nav-inner">
      <a id="logoBtn" href="#" aria-label="Home"></a>
      <div class="nav-links">
        <a id="navProducts">Products</a>
        <a id="navFeatures">Features</a>
        <a id="navFaq">FAQ</a>
        <a>Discord</a>
      </div>
      <div class="nav-actions">
        <button class="nav-login" id="navLogin">Operator Login</button>
      </div>
    </div>
  </nav>

  <div id="homeView">
    <header class="hero">
      <div class="hero-grid"></div>
      <div class="hero-inner">
        <div>
          <h1>
            <span class="hl"><span>Own the</span></span>
            <span class="hl"><span><em>kernel.</em></span></span>
            <span class="hl"><span>Own the game.</span></span>
          </h1>
          <p class="hero-sub">Private kernel driver, external toolkit, aimbot build method, and source template. <b>Zero detections since day one.</b> Crypto checkout, instant key, updates included.</p>
          <div class="hero-ctas">
            <a href="#products" class="btn btn-primary">Browse products</a>
            <a class="btn btn-ghost">Discord</a>
          </div>
        </div>
        <div class="term">
          <div class="term-bar">
            <span class="term-dot" style="background:#ff5f57"></span>
            <span class="term-dot" style="background:#febc2e"></span>
            <span class="term-dot" style="background:#28c840"></span>
            <span class="term-title">kernelcore@ring0:~</span>
          </div>
          <div class="term-body">
            <div class="tl t-1 visible"><span class="w">C:WINDOWS\system32&gt;</span><span class="type-text"> kernelcore --load</span></div>
            <div class="tl t-2"><span class="plus">[+] </span>Loaded Driver <span class="c-success">v1.4.2</span></div>
            <div class="tl t-3"><span class="plus">[+]</span> <span class="c-eac">EAC</span> <span class="c-success">Bypassed &amp; Evaded</span></div>
            <div class="tl t-4"><span class="plus">[+]</span> <span class="c-be">BattlEye</span> <span class="c-success">Bypassed &amp; Evaded</span></div>
            <div class="tl t-5"><span class="c-warn">[!]</span> fortniteclient-win64-shipping.exe <span class="c-success">attached</span></div>
            <div class="tl t-6"><span class="w">&gt;</span> <span class="cursor"></span></div>
          </div>
        </div>
      </div>
    </header>

    <div class="ticker-wrap">
      <div class="ticker" id="ticker">
        <span>KERNEL DRIVER FULLY UD</span>
        <span>EAC BATTLEYE VANGUARD BYPASS</span>
        <span>INSTANT CRYPTO DELIVERY</span>
        <span>SOURCE CODE AVAILABLE</span>
        <span>24/7 DISCORD SUPPORT</span>
        <span>UPDATES WITH EVERY PATCH</span>
        <span>ZERO BANS SINCE LAUNCH</span>
        <span>STREAM PROOF OVERLAY</span>
      </div>
    </div>

    <section id="products">
      <div class="container">
        <div class="sec-head rv">
          <div class="sec-kicker">The catalog</div>
          <h2 class="sec-title">Products</h2>
          <p class="sec-desc">Built in-house. Burned on live lobbies before every drop.</p>
        </div>
        <div class="pgrid">
          <article class="pcard rv" data-product="driver">
            <div class="pcard-imgwrap"><img class="pcard-img" src="assets/Products/KernelDriver.png" alt="Kernel Driver"></div>
            <div class="pcard-body">
              <div class="pcard-top">
                <span class="pbadge b-hot">Best Seller</span>
              </div>
              <div class="pcard-label">Kernel Mode</div>
              <h3 class="pcard-title">Kernel Driver</h3>
              <p class="pcard-desc">Signed kernel driver with hypervisor bypass. Full anti-cheat evasion.</p>
              <ul class="pfeats">
                <li>Signed</li>
                <li>EAC, BattlEye, Vanguard bypass</li>
                <li>Read and write process memory</li>
              </ul>
              <div class="ver-toggle" id="verToggleDrvCard">
                <button class="active" data-v="compiled">Compiled</button>
                <button data-v="source">Source</button>
              </div>
              <div class="drv-toggle" id="drvToggle">
                <button class="active" data-v="1day">1 Day</button>
                <button data-v="1week">1 Week</button>
                <button data-v="1month">1 Month</button>
              </div>
              <div class="qty-stepper license-opts" id="drvQtyCard">
                <button data-d="-1">-</button>
                <span class="qty-value" id="drvQtyCardVal">5</span>
                <button data-d="1">+</button>
              </div>
              <p class="source-note">Source code is a one-time purchase. No license quantity selection.</p>
              <div class="pcard-bottom">
                <div>
                  <span class="price" id="drvCardPrice">$45</span>
                  <span class="price-old">$80</span>
                  <div class="price-note">Crypto only</div>
                </div>
                <button class="btn btn-primary view-btn" data-page="driver">View product</button>
              </div>
            </div>
          </article>

          <article class="pcard rv rv-d1" data-product="cheat">
            <div class="pcard-imgwrap"><img class="pcard-img" src="assets/Products/Fully UD Fortnite External.png" alt="RGB gaming battlestation"></div>
            <div class="pcard-body">
              <div class="pcard-top">
                <span class="pbadge b-pop">Popular</span>
              </div>
              <div class="pcard-label">FUD External Cheat</div>
              <h3 class="pcard-title">Fortnite Cheat</h3>
              <p class="pcard-desc">External cheat with aimbot, ESP, radar, and stream-proof overlay.</p>
              <ul class="pfeats">
                <li>legit aimbot modes</li>
                <li>Player, loot, chest ESP</li>
                <li>Togglable Stream proof bypass</li>
                <li>Config system included</li>
              </ul>
              <div class="bundle-select" id="bundleSelectCard">
                <label>Bundle options</label>
                <div class="dropdown-trigger">
                  <span class="dropdown-current" data-value="base">Cheat only — $99</span>
                  <span class="dropdown-arrow">&#9662;</span>
                </div>
                <div class="dropdown-menu">
                  <div class="dropdown-option selected" data-value="base">Cheat only — $99</div>
                  <div class="dropdown-option" data-value="driver">Cheat + driver — $159 <span class="save">save $20</span></div>
                  <div class="dropdown-option" data-value="method">Cheat + aimbot method — $135 <span class="save">save $13</span></div>
                  <div class="dropdown-option" data-value="full">Cheat + driver + method — $195 <span class="save">save $33</span></div>
                </div>
              </div>
              <div class="pcard-bottom">
                <div>
                  <span class="price" id="cheatCardPrice">$99</span>
                  <span class="price-old">$80</span>
                  <div class="price-note">Crypto only</div>
                </div>
                <button class="btn btn-primary view-btn" data-page="cheat">View product</button>
              </div>
            </div>
          </article>

          <article class="pcard rv rv-d2" data-product="template">
            <div class="pcard-imgwrap"><img class="pcard-img" src="assets/Products/template.png" alt="Code on dark screen"></div>
            <div class="pcard-body">
              <div class="pcard-top">
                <span class="pbadge b-pop">Source</span>
              </div>
              <div class="pcard-label">C++ Fortnite External Template</div>
              <h3 class="pcard-title">Cheat Template</h3>
              <p class="pcard-desc">C++20 base with overlay, memory class, entity loop, and renderer.</p>
              <ul class="pfeats">
                <li>Clean C++20 codebase</li>
                <li>ImGui and DX11 renderer</li>
                <li>Memory abstraction layer</li>
                <li>Entity caching and bones</li>
              </ul>
              <div class="pcard-bottom">
                <div>
                  <span class="price" id="templateCardPrice">$20</span>
                  <span class="price-old">$35</span>
                  <div class="price-note">Crypto only</div>
                </div>
                <button class="btn btn-primary view-btn" data-page="template">View product</button>
              </div>
            </div>
          </article>

          <article class="pcard rv rv-d3" data-product="method">
            <div class="pcard-imgwrap"><img class="pcard-img" src="assets/Products/AimbotMethod.png" alt="Dark motherboard close-up"></div>
            <div class="pcard-body">
              <div class="pcard-top">
                <span class="pbadge b-pop">Guide</span>
              </div>
              <div class="pcard-label">Method</div>
              <h3 class="pcard-title">Aimbot Method</h3>
              <p class="pcard-desc">Writeup on building undetected aimbots. FOV, smoothing, input methods, evasion.</p>
              <ul class="pfeats">
                <li>10+ page document</li>
                <li>Full C++ source snippets &amp; Examples</li>
                <li>Smoothing and humanization</li>
                <li>Detection vectors &amp; Aimbot bypass explained</li>
              </ul>
              <div class="pcard-bottom">
                <div>
                  <span class="price" id="methodCardPrice">$49</span>
                  <span class="price-old">$69</span>
                  <div class="price-note">Crypto only</div>
                </div>
                <button class="btn btn-primary view-btn" data-page="method">View product</button>
              </div>
            </div>
          </article>
        </div>
      </div>
    </section>

    <div class="showcase rv" id="showcase">
      <img class="showcase-img" src="assets/Products/Cpu.png" alt="Neon microchip on black background">
      <div class="showcase-overlay">
        <div class="showcase-inner">
          <h3>Built at ring 0.<br><em>Tuned for war.</em></h3>
          <p>Every product runs on our private kernel driver — signed, mapped, and rebuilt within hours of every anti-cheat patch.</p>
        </div>
      </div>
    </div>

    <div class="strip" id="features">
      <div class="container">
        <div class="strip-grid">
          <div class="strip-item rv">
            <span class="strip-num">01</span>
            <h4>Fully undetected</h4>
            <p>Kernel-level bypasses. No bans since launch. Updated within hours of every patch.</p>
          </div>
          <div class="strip-item rv rv-d1">
            <span class="strip-num">02</span>
            <h4>Instant delivery</h4>
            <p>Pay with crypto, get your key and download link immediately. No waiting.</p>
          </div>
          <div class="strip-item rv rv-d2">
            <span class="strip-num">03</span>
            <h4>Source available</h4>
            <p>Driver ships compiled or with full source. Every product includes updates.</p>
          </div>
          <div class="strip-item rv rv-d3">
            <span class="strip-num">04</span>
            <h4>24/7 support</h4>
            <p>Active Discord. Setup help, troubleshooting, configs, around the clock.</p>
          </div>
        </div>
      </div>
    </div>

    <section id="faq">
      <div class="container">
        <div class="sec-head rv">
          <div class="sec-kicker">Support</div>
          <h2 class="sec-title">Questions.</h2>
        </div>
        <div class="faq-wrap rv">
          <div class="faq-item">
            <button class="faq-q">Is this safe to use on my main account?<span class="faq-icon">+</span></button>
            <div class="faq-a"><p>All products are fully undetected as of the latest patch. We recommend a secondary account regardless. Our driver has maintained a zero-ban record since release.</p></div>
          </div>
          <div class="faq-item">
            <button class="faq-q">How does delivery work?<span class="faq-icon">+</span></button>
            <div class="faq-a"><p>Fully automated. After your crypto payment confirms on-chain, you receive your license key and download link instantly. No manual approval.</p></div>
          </div>
          <div class="faq-item">
            <button class="faq-q">Why crypto only?<span class="faq-icon">+</span></button>
            <div class="faq-a"><p>Crypto keeps things private, fast, and borderless. We accept BTC, ETH, LTC, and USDT. Payments confirm in minutes.</p></div>
          </div>
          <div class="faq-item">
            <button class="faq-q">Do I get updates?<span class="faq-icon">+</span></button>
            <div class="faq-a"><p>Yes. Every purchase includes updates for the covered period. New builds ship within hours of every Fortnite patch. Re-download from your panel anytime.</p></div>
          </div>
          <div class="faq-item">
            <button class="faq-q">Refund policy?<span class="faq-icon">+</span></button>
            <div class="faq-a"><p>All sales are final due to the digital nature. If you hit a technical issue, support will resolve it or replace your product.</p></div>
          </div>
        </div>
      </div>
    </section>
  </div>

  <div class="ppage" id="page-driver">
    <div class="container">
      <button class="back-btn">&#8592; All products</button>
      <div class="ppage-hero">
        <div>
          <div class="ppage-bannerwrap"><img class="ppage-banner" src="assets/Products/KernelDriver.png" alt="CPU on dark circuit board"></div>
          <span class="ppage-badge">Ring 0 / Kernel</span>
          <h1>Kernel Driver</h1>
          <p class="ppage-sub">Custom signed kernel driver with manual mapping, hypervisor bypass, and full anti-cheat evasion. The foundation every serious cheat is built on. Works with EAC and BattlEye protected titles.</p>
          <div class="ppage-meta">
            <div class="ppm-item"><span class="ppm-val"><em>Zero</em></span><span class="ppm-lbl">Detections</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Ring 0</em></span><span class="ppm-lbl">Access level</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Included</em></span><span class="ppm-lbl">Updates</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>2+</em></span><span class="ppm-lbl">Users</span></div>
          </div>
        </div>
        <div class="co-side">
          <div class="co-price-row">
            <span class="co-price" id="coDrvPrice">$45</span>
            <span class="co-old" id="coDrvOld">$80</span>
          </div>
          <div class="co-note">Subscription / updates included</div>
          <div class="ver-toggle" id="verToggleDrvPage">
            <button class="active" data-v="compiled">Compiled</button>
            <button data-v="source">Source</button>
          </div>
          <div class="drv-toggle" id="drvTogglePage">
            <button class="active" data-v="1day">1 Day</button>
            <button data-v="1week">1 Week</button>
            <button data-v="1month">1 Month</button>
          </div>
          <div class="qty-stepper license-opts" id="drvQtyPage">
            <button data-d="-1">-</button>
            <span class="qty-value" id="drvQtyPageVal">5</span>
            <button data-d="1">+</button>
          </div>
          <p class="source-note">Source code is a one-time purchase. No license quantity selection.</p>
          <div class="co-label">Select crypto</div>
          <div class="co-opts" id="coOptsDrv"></div>
          <button class="co-btn pay-btn" data-product="driver">Checkout</button>
          <div class="co-meta">
            <span>Instant delivery after confirmation</span>
            <span>Updates included</span>
            <span>24/7 Discord support</span>
          </div>
        </div>
      </div>
      <div class="pp-feats">
        <div class="pp-feat rv"><div class="pp-feat-icon">S</div><h4>Signed</h4><p>No test mode or DSE bypass needed. Loads clean on stock Windows 10 and 11.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">B</div><h4>Multi-AC bypass</h4><p>EAC, BattlEye, and Vanguard evasion. Updated within hours of every anti-cheat patch.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">R</div><h4>Full RW access</h4><p>Read and write process memory from ring 0. Safe, fast, completely undetected.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">U</div><h4>Updates included</h4><p>New builds within hours of every Fortnite patch. Re-download anytime.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">C</div><h4>Compiled or Source</h4><p>Binary plus loader, or full Visual Studio project with build scripts and docs.</p></div>
      </div>
    </div>
  </div>

  <div class="ppage" id="page-cheat">
    <div class="container">
      <button class="back-btn">&#8592; All products</button>
      <div class="ppage-hero">
        <div>
          <div class="ppage-bannerwrap"><img class="ppage-banner" src="assets/Products/Fully UD Fortnite External.png" alt="RGB gaming battlestation"></div>
          <span class="ppage-badge">External</span>
          <h1>Fortnite Undetected Cheat</h1>
          <p class="ppage-sub">Complete external cheat built on our private driver. Aimbot, ESP, radar, stream-proof overlay. Zero detections since release. Auto-updates after every patch.</p>
          <div class="ppage-meta">
            <div class="ppm-item"><span class="ppm-val"><em>Zero</em></span><span class="ppm-lbl">Detections</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>2</em></span><span class="ppm-lbl">Aimbot modes</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Auto</em></span><span class="ppm-lbl">Updates</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>OBS</em></span><span class="ppm-lbl">Stream proof</span></div>
          </div>
        </div>
        <div class="co-side">
          <div class="bundle-select page-bundle-select" id="bundleSelectPage">
            <label>Bundle options</label>
            <div class="dropdown-trigger">
              <span class="dropdown-current" data-value="base">Cheat only — $99</span>
              <span class="dropdown-arrow">&#9662;</span>
            </div>
            <div class="dropdown-menu">
              <div class="dropdown-option selected" data-value="base">Cheat only — $99</div>
              <div class="dropdown-option" data-value="driver">Cheat + driver — $159 <span class="save">save $20</span></div>
              <div class="dropdown-option" data-value="method">Cheat + aimbot method — $135 <span class="save">save $13</span></div>
              <div class="dropdown-option" data-value="full">Cheat + driver + method — $195 <span class="save">save $33</span></div>
            </div>
          </div>
          <div class="co-price-row">
            <span class="co-price" id="coCheatPrice">$99</span>
            <span class="co-old">$129</span>
          </div>
          <div class="co-note">One-time / Lifetime updates</div>
          <div class="co-label">Select crypto</div>
          <div class="co-opts" id="coOptsCheat"></div>
          <button class="co-btn pay-btn" data-product="cheat">Checkout</button>
          <div class="co-meta">
            <span>Instant delivery after confirmation</span>
            <span>Lifetime updates included</span>
            <span>24/7 Discord support</span>
          </div>
        </div>
      </div>
      <div class="pp-feats">
        <div class="pp-feat rv"><div class="pp-feat-icon">A</div><h4>Dual aimbot modes</h4><p>Silent for rage, legit with smoothing for closet. FOV, bone selection, target priority.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">E</div><h4>Full ESP</h4><p>Players, loot, chests, vehicles, storm circle. Distance fading, chams, skeletons.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">R</div><h4>Radar and overlay</h4><p>Stream-proof OBS bypass. Your viewers see nothing but clean gameplay.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">C</div><h4>Config system</h4><p>Save, load, and share configs. Active community config library included.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">U</div><h4>Auto-update</h4><p>New build pushed within hours of every Fortnite patch. No manual downloads.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">D</div><h4>Driver included</h4><p>Built on our private kernel driver. No separate purchase needed.</p></div>
      </div>
    </div>
  </div>

  <div class="ppage" id="page-template">
    <div class="container">
      <button class="back-btn">&#8592; All products</button>
      <div class="ppage-hero">
        <div>
          <div class="ppage-bannerwrap"><img class="ppage-banner" src="assets/Products/template.png" alt="Code on dark screen"></div>
          <span class="ppage-badge">C++20 / Source</span>
          <h1>External Cheat Template</h1>
          <p class="ppage-sub">Full C++20 external cheat base with overlay, memory class, entity loop, and rendering. Documented, commented, ready to extend. Build your own private cheat on a solid foundation.</p>
          <div class="ppage-meta">
            <div class="ppm-item"><span class="ppm-val"><em>C++20</em></span><span class="ppm-lbl">Standard</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>DX11</em></span><span class="ppm-lbl">Renderer</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Full</em></span><span class="ppm-lbl">Source</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Docs</em></span><span class="ppm-lbl">Included</span></div>
          </div>
        </div>
        <div class="co-side">
          <div class="co-price-row">
            <span class="co-price" id="coTemplatePrice">$20</span>
            <span class="co-old">$35</span>
          </div>
          <div class="co-note">Source / Lifetime access</div>
          <div class="co-label">Select crypto</div>
          <div class="co-opts" id="coOptsTemplate"></div>
          <button class="co-btn pay-btn" data-product="template">Checkout</button>
          <div class="co-meta">
            <span>Instant delivery after confirmation</span>
            <span>Full source included</span>
            <span>24/7 Discord support</span>
          </div>
        </div>
      </div>
      <div class="pp-feats">
        <div class="pp-feat rv"><div class="pp-feat-icon">C</div><h4>Clean C++20 base</h4><p>Modern architecture with clear separation. Every section commented for readability.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">I</div><h4>ImGui and DX11</h4><p>Full rendering setup with menu system, ESP drawing helpers, frame timing.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">M</div><h4>Memory abstraction</h4><p>Read/write layer with driver communication. Swap in your own driver easily.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">E</div><h4>Entity and bones</h4><p>Caching system, bone parsing, matrix transforms. Ready for aimbot logic.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">D</div><h4>Documentation</h4><p>Setup guide, architecture overview, and extension examples included.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">V</div><h4>VS 2022 project</h4><p>Ready to build. No missing dependencies or cryptic setup steps.</p></div>
      </div>
    </div>
  </div>

  <div class="ppage" id="page-method">
    <div class="container">
      <button class="back-btn">&#8592; All products</button>
      <div class="ppage-hero">
        <div>
          <div class="ppage-bannerwrap"><img class="ppage-banner" src="assets/Products/AimbotMethod.png" alt="Dark motherboard close-up"></div>
          <span class="ppage-badge">Technical Writeup</span>
          <h1>Aimbot Method</h1>
          <p class="ppage-sub">Complete writeup on building undetected aimbots for Fortnite. Bone scanning, FOV checks, smoothing math, input methods, and evasion techniques. 50+ pages with full C++ source.</p>
          <div class="ppage-meta">
            <div class="ppm-item"><span class="ppm-val"><em>50+</em></span><span class="ppm-lbl">Pages</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>C++</em></span><span class="ppm-lbl">Source included</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>Full</em></span><span class="ppm-lbl">Coverage</span></div>
            <div class="ppm-item"><span class="ppm-val"><em>PDF</em></span><span class="ppm-lbl">Format</span></div>
          </div>
        </div>
        <div class="co-side">
          <div class="co-price-row">
            <span class="co-price" id="coMethodPrice">$49</span>
            <span class="co-old">$69</span>
          </div>
          <div class="co-note">Digital / Lifetime access</div>
          <div class="co-label">Select crypto</div>
          <div class="co-opts" id="coOptsMethod"></div>
          <button class="co-btn pay-btn" data-product="method">Checkout</button>
          <div class="co-meta">
            <span>Instant delivery after confirmation</span>
            <span>Full source snippets included</span>
            <span>24/7 Discord support</span>
          </div>
        </div>
      </div>
      <div class="pp-feats">
        <div class="pp-feat rv"><div class="pp-feat-icon">D</div><h4>50+ page document</h4><p>Every concept explained from first principles. No hand-waving, no skipped steps.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">C</div><h4>C++ source snippets</h4><p>Full working code for each technique. Copy, adapt, and learn from real implementations.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">M</div><h4>Smoothing math</h4><p>Humanization algorithms, bezier curves, reaction delay simulation. Passes manual review.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">I</div><h4>Input methods</h4><p>SendInput vs driver input compared. Detection risks and when to use each.</p></div>
        <div class="pp-feat rv"><div class="pp-feat-icon">V</div><h4>Detection vectors</h4><p>How anti-cheat catches aimbots and how to avoid every known vector.</p></div>
        <div class="pp-feat rv rv-d1"><div class="pp-feat-icon">B</div><h4>Bone scanning</h4><p>Head, chest, pelvis selection. Dynamic bone switching based on visibility.</p></div>
      </div>
    </div>
  </div>

  <footer>
    <div class="container">
      <div class="foot-grid">
        <div class="foot-brand rv">
          <div id="footLogo" aria-label="Home"></div>
        </div>
        <div class="foot-links">
          <div class="foot-col">
            <h5>Shop</h5>
            <a class="foot-page" data-page="driver">Kernel driver</a>
            <a class="foot-page" data-page="cheat">Full cheat</a>
            <a class="foot-page" data-page="template">Template</a>
            <a class="foot-page" data-page="method">Aimbot method</a>
          </div>
          <div class="foot-col">
            <h5>Support</h5>
            <a>Discord</a>
            <a id="footFaq">FAQ</a>
            <a>Status</a>
          </div>
          <div class="foot-col">
            <h5>Legal</h5>
            <a>Terms</a>
            <a>Refunds</a>
          </div>
        </div>
      </div>
      <div class="foot-bottom">
        <span>&copy; 2026 Kernel Core</span>
        <span>Educational purposes only</span>
      </div>
    </div>
  </footer>

  <div class="login-overlay" id="loginOverlay">
    <div class="login-modal">
      <button class="login-close" id="loginClose">&#10005;</button>
      <div class="login-brand">
        <div class="logo-mark">KC</div>
        <h2>Operator Access</h2>
        <p>Restricted area. Authorized personnel only.</p>
      </div>
      <form id="loginForm" autocomplete="off">
        <div class="login-field">
          <label for="loginUser">Username</label>
          <input type="text" id="loginUser" placeholder="operator" autocomplete="off">
        </div>
        <div class="login-field">
          <label for="loginPass">Password</label>
          <input type="password" id="loginPass" placeholder="kernelcore" autocomplete="off">
        </div>
        <button type="submit" class="login-btn" id="loginBtn">Authenticate</button>
        <div class="login-error" id="loginError"></div>
        <div class="login-hint">Mock mode: username <span>operator</span> / password <span>kernelcore</span></div>
      </form>
    </div>
  </div>

  <div class="overlay" id="payModal">
    <div class="modal">
      <button class="modal-close" id="payClose">&#10005;</button>
      <div class="pay-body">
        <div class="pay-badge">Demo checkout</div>
        <div class="pay-amount" id="pAmt">0 BTC</div>
        <div class="pay-name" id="pName">Bitcoin (BTC network)</div>
        <div class="qr-box"><svg id="qrSvg" viewBox="0 0 29 29" shape-rendering="crispEdges" xmlns="http://www.w3.org/2000/svg"></svg></div>
        <div class="pay-addr">
          <span id="pAddr">bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh</span>
          <button class="copy-btn" id="copyBtn">Copy</button>
        </div>
        <div class="pay-timer" id="pTimer">Expires in 15:00</div>
        <div class="pay-status">Demo mode. No real payment is processed and no funds can be sent.</div>
        <div class="mock-note">Mock checkout — payment processor not connected</div>
      </div>
    </div>
  </div>

  <script>
    const P = {
      driver: {
        durations: {
          '1day': { qty: 5, basePrice: 45, each: 9, oldPrice: 80 },
          '1week': { qty: 4, basePrice: 45, each: 11.25, oldPrice: 80 },
          '1month': { qty: 1, basePrice: 60, each: 60, oldPrice: 80 }
        },
        sourcePrice: 550,
        sourceOldPrice: 800,
        hasToggle: true
      },
      cheat: { price: 99, bundle: { base: 99, driver: 159, method: 135, full: 195 } },
      template: { price: 20 },
      method: { price: 49 }
    };

    const rates = { BTC: 0.000015, ETH: 0.00028, LTC: 0.12, USDT: 1 };
    const cNames = { BTC: "Bitcoin", ETH: "Ethereum", LTC: "Litecoin", USDT: "Tether" };
    const cAddrs = {
      BTC: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
      ETH: "0x71C7656EC7ab88b098defB751B7401B5f6d8976F",
      LTC: "ltc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
      USDT: "TEXAMPLE9xYzAbCdEfGhIjKlMnOpQrStUvWx"
    };

    const optIds = { driver: 'coOptsDrv', cheat: 'coOptsCheat', template: 'coOptsTemplate', method: 'coOptsMethod' };
    const bundleLabels = { base: '$99', driver: '$159', method: '$135', full: '$195' };

    let curPage = null;
    let drvVer = '1day';
    let drvVersion = 'compiled';
    let drvQty = 5;
    let cheatBundleValue = 'base';
    let selCrypto = {};
    let payTimer = null;
    let revealObs = null;

    function hashStr(s) {
      let h = 2166136261;
      for (let i = 0; i < s.length; i++) {
        h ^= s.charCodeAt(i);
        h = Math.imul(h, 16777619);
      }
      return h >>> 0;
    }

    function makeQR(seed) {
      const N = 29;
      let h = hashStr(seed);
      const rand = () => { h ^= h << 13; h ^= h >>> 17; h ^= h << 5; h >>>= 0; return h / 4294967296; };
      let rects = '';
      const finder = (x, y) => {
        rects += `<rect x="${x}" y="${y}" width="7" height="7" fill="#000"/>`;
        rects += `<rect x="${x + 1}" y="${y + 1}" width="5" height="5" fill="#fff"/>`;
        rects += `<rect x="${x + 2}" y="${y + 2}" width="3" height="3" fill="#000"/>`;
      };
      for (let y = 0; y < N; y++) {
        for (let x = 0; x < N; x++) {
          const inF = (x < 8 && y < 8) || (x >= N - 8 && y < 8) || (x < 8 && y >= N - 8);
          if (!inF && rand() > .52) rects += `<rect x="${x}" y="${y}" width="1" height="1" fill="#000"/>`;
        }
      }
      finder(0, 0);
      finder(N - 7, 0);
      finder(0, N - 7);
      document.getElementById('qrSvg').innerHTML = rects;
    }

    function buildCrypto(id) {
      const el = document.getElementById(id);
      if (!el) return;
      const coins = [
        { c: 'BTC', n: 'Bitcoin', net: 'BTC network', cls: 'ci-btc', img: 'assets/Crypto/BTC.png' },
        { c: 'ETH', n: 'Ethereum', net: 'ERC-20', cls: 'ci-eth', img: 'assets/Crypto/ETH.png' },
        { c: 'LTC', n: 'Litecoin', net: 'LTC network', cls: 'ci-ltc', img: 'assets/Crypto/LTC.png' },
        { c: 'USDT', n: 'Tether', net: 'TRC-20', cls: 'ci-usdt', img: 'assets/Crypto/LTC.png' }
      ];
      el.innerHTML = coins.map((coin, i) =>
        `<div class="co-opt${i === 0 ? ' selected' : ''}" data-c="${coin.c}">
          <div class="ci ${coin.cls}"><img src="${coin.img}" alt="${coin.c}" loading="lazy"></div>
          <div><div class="cn">${coin.n}</div><div class="cnet">${coin.net}</div></div>
          <div class="ccheck"></div>
        </div>`
      ).join('');
      selCrypto[id] = 'BTC';
      el.querySelectorAll('.co-opt').forEach(opt => {
        opt.addEventListener('click', () => {
          el.querySelectorAll('.co-opt').forEach(o => o.classList.remove('selected'));
          opt.classList.add('selected');
          selCrypto[id] = opt.dataset.c;
        });
      });
    }

    function openPage(k) {
      document.getElementById('homeView').style.display = 'none';
      document.querySelectorAll('.ppage').forEach(p => p.classList.remove('active'));
      const target = document.getElementById('page-' + k);
      if (target) {
        target.classList.add('active');
        window.scrollTo(0, 0);
        curPage = k;
        history.replaceState(null, '', '#' + k);
        requestAnimationFrame(() => observeReveals(target));
      }
    }

    function showHome() {
      document.querySelectorAll('.ppage').forEach(p => p.classList.remove('active'));
      document.getElementById('homeView').style.display = 'block';
      window.scrollTo(0, 0);
      curPage = null;
      history.replaceState(null, '', '#');
      observeReveals(document.getElementById('homeView'));
      runTerminal();
    }

    function observeReveals(scope) {
      if (!('IntersectionObserver' in window)) {
        document.querySelectorAll('.rv').forEach(el => el.classList.add('in'));
        return;
      }
      if (!revealObs) {
        revealObs = new IntersectionObserver(entries => {
          entries.forEach(e => {
            if (e.isIntersecting) {
              e.target.classList.add('in');
              revealObs.unobserve(e.target);
            }
          });
        }, { threshold: .12 });
      }
      (scope || document).querySelectorAll('.rv:not(.in)').forEach(el => revealObs.observe(el));
    }

    function updateQtyUI() {
      document.getElementById('drvQtyCardVal').textContent = drvQty;
      document.getElementById('drvQtyPageVal').textContent = drvQty;
    }

    function setSourceMode(on) {
      document.querySelectorAll('#verToggleDrvCard, #verToggleDrvPage').forEach(el => el.classList.toggle('source-only', on));
      document.querySelectorAll('.license-opts').forEach(el => el.style.display = on ? 'none' : 'inline-flex');
      document.querySelectorAll('.source-note').forEach(el => el.style.display = on ? 'block' : 'none');
    }

    function applyDrvOptions(duration, version) {
      const d = P.driver.durations[duration];
      drvVer = duration;
      if (version) drvVersion = version;
      if (drvQty < d.qty) drvQty = d.qty;
      updateQtyUI();

      document.querySelectorAll('#drvToggle button, #drvTogglePage button').forEach(b => {
        b.classList.toggle('active', b.dataset.v === duration);
        b.style.display = drvVersion === 'source' ? 'none' : 'flex';
      });

      document.querySelectorAll('#verToggleDrvCard button, #verToggleDrvPage button').forEach(b => {
        b.classList.toggle('active', b.dataset.v === drvVersion);
      });

      setSourceMode(drvVersion === 'source');

      if (drvVersion === 'source') {
        document.getElementById('drvCardPrice').textContent = '$' + P.driver.sourcePrice;
        document.getElementById('coDrvPrice').textContent = '$' + P.driver.sourcePrice;
        document.getElementById('coDrvOld').textContent = '$' + P.driver.sourceOldPrice;
        document.querySelectorAll('.co-note').forEach(n => {
          if (n.textContent.includes('Subscription')) n.textContent = 'One-time / Lifetime source access';
        });
      } else {
        const total = Math.round(d.each * drvQty);
        document.getElementById('drvCardPrice').textContent = '$' + total;
        document.getElementById('coDrvPrice').textContent = '$' + total;
        document.getElementById('coDrvOld').textContent = '$' + d.oldPrice;
        document.querySelectorAll('.co-note').forEach(n => {
          if (n.textContent.includes('One-time')) n.textContent = 'Subscription / updates included';
        });
      }
    }

    function syncBundle(value) {
      cheatBundleValue = value;
      document.getElementById('cheatCardPrice').textContent = bundleLabels[value];
      document.getElementById('coCheatPrice').textContent = bundleLabels[value];
      updateDropdowns(value);
    }

    function updateDropdowns(value) {
      [document.getElementById('bundleSelectCard'), document.getElementById('bundleSelectPage')].forEach(dd => {
        if (!dd) return;
        const current = dd.querySelector('.dropdown-current');
        const selected = dd.querySelector('.dropdown-option.selected');
        const next = dd.querySelector('.dropdown-option[data-value="' + value + '"]');
        if (selected) selected.classList.remove('selected');
        if (next) next.classList.add('selected');
        if (current) {
          current.dataset.value = value;
          current.textContent = bundleLabels[value];
        }
      });
    }

    function initDropdown(dd, cb) {
      if (!dd) return;
      const trigger = dd.querySelector('.dropdown-trigger');
      const current = dd.querySelector('.dropdown-current');
      trigger.addEventListener('click', e => {
        e.stopPropagation();
        document.querySelectorAll('.bundle-select.open').forEach(b => { if (b !== dd) b.classList.remove('open'); });
        dd.classList.toggle('open');
      });
      dd.querySelectorAll('.dropdown-option').forEach(opt => {
        opt.addEventListener('click', () => {
          dd.querySelectorAll('.dropdown-option').forEach(o => o.classList.remove('selected'));
          opt.classList.add('selected');
          current.dataset.value = opt.dataset.value;
          current.textContent = bundleLabels[opt.dataset.value];
          dd.classList.remove('open');
          cb(opt.dataset.value);
        });
      });
    }

    function getPrice(k) {
      const p = P[k];
      if (p.hasToggle) {
        if (drvVersion === 'source') return p.sourcePrice;
        const d = p.durations[drvVer || '1day'];
        return d ? Math.round(d.each * drvQty) : 45;
      }
      if (k === 'cheat') return p.bundle[cheatBundleValue || 'base'];
      return p.price;
    }

    function startPay(k) {
      const usd = getPrice(k);
      const optId = optIds[k];
      const c = selCrypto[optId] || 'BTC';
      const amt = (usd * rates[c]).toFixed(c === 'USDT' ? 2 : 6);
      document.getElementById('pAmt').textContent = amt + ' ' + c;
      document.getElementById('pName').textContent = cNames[c];
      document.getElementById('pAddr').textContent = cAddrs[c];
      makeQR(cAddrs[c]);
      document.getElementById('payModal').classList.add('open');
      document.body.style.overflow = 'hidden';
      let s = 15 * 60;
      document.getElementById('pTimer').textContent = 'Expires in 15:00';
      clearInterval(payTimer);
      payTimer = setInterval(() => {
        s--;
        document.getElementById('pTimer').textContent = 'Expires in ' + Math.floor(s / 60) + ':' + (s % 60).toString().padStart(2, '0');
        if (s <= 0) clearInterval(payTimer);
      }, 1000);
    }

    function closePay() {
      document.getElementById('payModal').classList.remove('open');
      document.body.style.overflow = '';
      clearInterval(payTimer);
    }

    let termAnimating = false;
    function runTerminal() {
      if (termAnimating) return;
      termAnimating = true;
      const lines = document.querySelectorAll('.term-body .tl');
      lines.forEach(l => {
        l.classList.remove('visible');
        l.style.opacity = '';
        l.style.transform = '';
      });
      const typeText = lines[0].querySelector('.type-text');
      if (typeText) {
        typeText.style.animation = 'none';
        void typeText.offsetWidth;
        typeText.style.animation = '';
      }
      let delay = 500;
      const typeMs = 2200;
      lines.forEach((_, i) => {
        setTimeout(() => { lines[i].classList.add('visible'); }, delay);
        if (i === 0) delay += typeMs;
        else delay += 700;
      });
      setTimeout(() => { termAnimating = false; }, delay + 200);
    }

    document.addEventListener('DOMContentLoaded', () => {
      Object.values(optIds).forEach(buildCrypto);

      document.querySelectorAll('.view-btn').forEach(btn => {
        btn.addEventListener('click', () => openPage(btn.dataset.page));
      });

      document.querySelectorAll('.back-btn').forEach(btn => {
        btn.addEventListener('click', showHome);
      });

      document.querySelectorAll('.foot-page').forEach(a => {
        a.addEventListener('click', () => openPage(a.dataset.page));
      });

      document.getElementById('logoBtn').addEventListener('click', e => { e.preventDefault(); showHome(); });
      document.getElementById('footLogo').addEventListener('click', showHome);

      const scrollTo = id => {
        showHome();
        setTimeout(() => document.getElementById(id).scrollIntoView({ behavior: 'smooth' }), 50);
      };
      document.getElementById('navProducts').addEventListener('click', () => scrollTo('products'));
      document.getElementById('navFeatures').addEventListener('click', () => scrollTo('features'));
      document.getElementById('navFaq').addEventListener('click', () => scrollTo('faq'));
      document.getElementById('footFaq').addEventListener('click', () => scrollTo('faq'));

      document.querySelectorAll('#drvQtyCard button, #drvQtyPage button').forEach(btn => {
        btn.addEventListener('click', () => {
          const d = parseInt(btn.dataset.d, 10);
          const minQty = P.driver.durations[drvVer].qty;
          const next = drvQty + d;
          if (next < minQty) return;
          drvQty = next;
          updateQtyUI();
          applyDrvOptions(drvVer, drvVersion);
        });
      });

      document.querySelectorAll('#drvToggle button, #drvTogglePage button').forEach(btn => {
        btn.addEventListener('click', () => applyDrvOptions(btn.dataset.v, drvVersion));
      });

      document.querySelectorAll('#verToggleDrvCard button, #verToggleDrvPage button').forEach(btn => {
        btn.addEventListener('click', () => applyDrvOptions(drvVer, btn.dataset.v));
      });

      document.querySelectorAll('.pay-btn').forEach(btn => {
        btn.addEventListener('click', () => startPay(btn.dataset.product));
      });

      document.getElementById('templateCardPrice').textContent = '$' + P.template.price;
      document.getElementById('coTemplatePrice').textContent = '$' + P.template.price;
      document.getElementById('methodCardPrice').textContent = '$' + P.method.price;
      document.getElementById('coMethodPrice').textContent = '$' + P.method.price;

      initDropdown(document.getElementById('bundleSelectCard'), val => syncBundle(val));
      initDropdown(document.getElementById('bundleSelectPage'), val => syncBundle(val));

      updateQtyUI();
      applyDrvOptions(drvVer, drvVersion);

      document.getElementById('payClose').addEventListener('click', closePay);
      document.getElementById('payModal').addEventListener('click', e => {
        if (e.target === e.currentTarget) closePay();
      });

      const loginOverlay = document.getElementById('loginOverlay');
    const loginForm = document.getElementById('loginForm');
    const loginError = document.getElementById('loginError');
    const loginBtn = document.getElementById('loginBtn');

    function openLogin() {
      loginOverlay.classList.add('open');
      requestAnimationFrame(() => loginOverlay.classList.add('fade'));
      document.body.style.overflow = 'hidden';
      loginError.textContent = '';
      document.getElementById('loginUser').focus();
    }

    function closeLogin() {
      loginOverlay.classList.remove('fade');
      setTimeout(() => {
        loginOverlay.classList.remove('open');
        document.body.style.overflow = '';
      }, 350);
    }

    document.getElementById('navLogin').addEventListener('click', openLogin);
    document.getElementById('loginClose').addEventListener('click', closeLogin);
    loginOverlay.addEventListener('click', e => {
      if (e.target === loginOverlay) closeLogin();
    });

    loginForm.addEventListener('submit', e => {
      e.preventDefault();
      const user = document.getElementById('loginUser').value.trim();
      const pass = document.getElementById('loginPass').value;
      loginBtn.disabled = true;
      loginError.textContent = '';
      setTimeout(() => {
        if (user === 'operator' && pass === 'kernelcore') {
          window.location.href = 'panel.html';
        } else {
          loginError.textContent = 'UNAUTHORIZED — invalid credentials';
          loginBtn.disabled = false;
          document.getElementById('loginPass').value = '';
        }
      }, 800);
    });

    document.getElementById('copyBtn').addEventListener('click', () => {
        const txt = document.getElementById('pAddr').textContent;
        const done = () => {
          const b = document.getElementById('copyBtn');
          b.textContent = 'Copied';
          setTimeout(() => b.textContent = 'Copy', 2000);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(txt).then(done).catch(done);
        } else {
          const ta = document.createElement('textarea');
          ta.value = txt;
          document.body.appendChild(ta);
          ta.select();
          try { document.execCommand('copy'); } catch (e) {}
          document.body.removeChild(ta);
          done();
        }
      });

      document.querySelectorAll('.faq-q').forEach(btn => {
        btn.addEventListener('click', () => {
          const item = btn.parentElement;
          const open = item.classList.contains('open');
          document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('open'));
          if (!open) item.classList.add('open');
        });
      });

      document.querySelectorAll('.pcard').forEach(c => {
        c.addEventListener('mousemove', e => {
          const r = c.getBoundingClientRect();
          c.style.setProperty('--mx', (e.clientX - r.left) + 'px');
          c.style.setProperty('--my', (e.clientY - r.top) + 'px');
        });
      });

      document.addEventListener('click', () => {
        document.querySelectorAll('.bundle-select.open').forEach(dd => dd.classList.remove('open'));
      });

      const t = document.getElementById('ticker');
      if (t) t.innerHTML += t.innerHTML;

      runTerminal();

      const hash = window.location.hash.replace('#', '');
      if (hash && P[hash]) openPage(hash);

      observeReveals(document);

      document.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
          closePay();
          closeLogin();
        }
      });

      const heroInner = document.querySelector('.hero-inner');
      if (heroInner && !window.matchMedia('(pointer: coarse)').matches) {
        document.addEventListener('mousemove', e => {
          const x = (e.clientX / window.innerWidth - .5) * 2;
          const y = (e.clientY / window.innerHeight - .5) * 2;
          heroInner.style.transform = `rotateY(${x * 1.5}deg) rotateX(${-y * 1.5}deg)`;
        });
      }
    });
  </script>
</body>
</html>
