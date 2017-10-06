# PupillometerIOS

This project uses the OpenCV framework for pupil detection. As the file was too big for GitHub, it must be downloaded seperatly. Installation depends on what version of xCode you are using.

xCode 8:
To use OpenCV in the program, download the IOS file from http://opencv.org/releases.html .

Once the file is downloaded, move it to the project directory.
...PupillometerIOS/Pupillometer/Pupillometer

xCode 9:
Do the same thing as xCode 8 instructions with an extra step. If the project wont launch due to errors such as..

<a href="https://imgbb.com/"><img src="https://image.ibb.co/b1kzQb/Screen_Shot_2017_10_06_at_9_01_22_pm.png" alt="Screen_Shot_2017_10_06_at_9_01_22_pm" border="0"></a>

..then you will simply need to comment out any sections of code from the OpenCV framework files that are causing the errors. Comment out the whole method, not just the line of code. Do it for each error you get in the OpenCV files.

<a href="https://ibb.co/bsGjrG"><img src="https://preview.ibb.co/gGLAWG/Screen_Shot_2017_10_06_at_9_01_41_pm.png" alt="Screen_Shot_2017_10_06_at_9_01_41_pm" border="0"></a>
<a href="https://ibb.co/hECPrG"><img src="https://preview.ibb.co/dbRjrG/Screen_Shot_2017_10_06_at_9_01_57_pm.png" alt="Screen_Shot_2017_10_06_at_9_01_57_pm" border="0"></a>
<a href="https://ibb.co/f7y8Jw"><img src="https://preview.ibb.co/igHPrG/Screen_Shot_2017_10_06_at_9_02_24_pm.png" alt="Screen_Shot_2017_10_06_at_9_02_24_pm" border="0"></a>
<a href="https://ibb.co/fYCDkb"><img src="https://preview.ibb.co/i0oVWG/Screen_Shot_2017_10_06_at_9_02_40_pm.png" alt="Screen_Shot_2017_10_06_at_9_02_40_pm" border="0"></a>



Here are some videos of the app in action:
Test 1: https://www.youtube.com/watch?v=2_J80i4GHX4

In this video, we can see at the start that the eyes are a very dark shade of brown and there is a large light reflection going over the iris and pupil. From this we can already tell it will be unlikely to yield an accurate detection. The results are as expected with the detected area being not lined up with the pupil.

Test 2: https://www.youtube.com/watch?v=zcM3qE_LTn8

In this video, the eyes are a lighter colour but there is still a lot of light reflection. The detection managed to pick up on the pupil in the second image but not the first.

Test 3: https://www.youtube.com/watch?v=bTw8YhOTgVY

For this video, the eyes are a night lighter colour but there is still some strong reflections in the eye that will make detection difficult. Again the results were as expected with the detection detecting other circles before the pupil. To give the user an option in these situations where the pupil is clear but not detected, the user can go to the parameter’s page. This allows the user to slightly alter the detection algorithm to possible yield an accurate result.

Test 4: https://www.youtube.com/watch?v=r0p6tU5jMEY

This test had very clear brown eyes but with a large light reflection. Due to the eye being clear, the detection was able to pick up on the pupil very accurately.

Test 5: https://www.youtube.com/watch?v=Og6dkHQWgqM

For this test, the eye is again a lighter coloured eye but this time with no reflections or light interference. This is the best possible environment for the detection process. As expected the pupil was easily detected.

Test 6: https://www.youtube.com/watch?v=jmoOVyaoPxQ

In this test, the same eye was used as test 5, but manual detection was utilised. This is an option for people to use when automatic detection isn’t working. The user simply lines up the circle with the pupil as accurately as they can.

