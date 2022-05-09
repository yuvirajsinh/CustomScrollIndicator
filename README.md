# CustomScrollIndicator
Recreation of Custom scroll indicator like CRED app.

[Flutter example is here](https://github.com/yuvirajsinh/custom_scroll_indicator)

## How it looks
You can see origianl behaviour here

<img src="/Videos/original_from_app.gif" width="500" height="500" />

Recreation

<img src="/Videos/recreation.gif" width="500" height="500" />

## Process
Observe -> Think -> Initial Implementation -> Few iteration -> Finishing touch -> Refactoring -> Done

## Though process (Initial observations)
1.  One container view, three subviews which moves based on scroll view position (This is exactly how I did).
2.  There is also one shape (Diamond) which rotates based on scroll view position and also changes it's position. If you observe closely it rotates 360° from stat to end of scrolling.
3.  Outer view has gradient effect which changes when scroll view is being scrolled.
4.  All calculations are based on current scroll view offset position (in percentage).

## Conslution
Initial implementation was easy but took some effort to imeplement finishing touch, like,
1.  Managing gradient position while scrolling.
2.  Managing behaviour when overscrolling.
3.  Diamond rotation

> _NOTE: I created it for learning purpose because I felt it challenging when I saw it first time. The code represents only my thoughts on how it might have been done in the app, it does not reqpresent original implementation. Original credit goes to CRED app designer/devs._
