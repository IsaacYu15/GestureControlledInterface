# GESTURE CONTROLLED INTERFACE FOR GAMING
Over the school term my friend, Spark and I got into a video game called Balatro. We decided to create a more immersive interface for this game
using gesture controls and LED strips that react to in game events and demoed the project at Scoratica's end of term event. **Demo:** [here!](https://www.youtube.com/watch?v=n3u-02MCs-k)

<p align="center">
  <img src="https://github.com/IsaacYu15/GestureControlledInterface/blob/main/Images/Image1.jpeg?raw=true" height="256">
  <img src="https://github.com/IsaacYu15/GestureControlledInterface/blob/main/Images/Image2.jpg?raw=true" height="256">
</p>

This project works by projecting the game onto a table using projection mapping with Resolume Arena. By mounting a webcam on
to the celing, we were able to track hand gestures above the table, mapping them to mouse movements and click using Python, OpenCV and MediaPipe.
Finally we developed a custom in game mod for Balatro which triggers lighting animations on the LED strips surrounding the table based on
various events, using ENTTEC’s ELM HTTP API, Steamodded and Lovely. For example, when a user achieves a high score, the table flashes faster and with brighter colours. 
