<h1 align="center">ARCountryInfo</h1>

## General Description

This augmented reality app has the scope of displaying informations about a country when the user presses on the virtual earth from the scene. The earth is represented by a sphere on which is mapped an earth texture. 

<p align="center">
    <img src="Demo_gifs/earth_rotating.gif"/>
</p>

In the right top is the button to enable or disable the clouds node. You can see the visual effect in the image below:

<p align="center">
    <img src="Demo_gifs/clouds_on_off.gif"/>
</p>

When the user presses on this texture the coordinates are translated in latitude and longitude, and these are sent to *CoreLocation* framework to determine the country in this particular point. Next to the earth node is a node which displays a webView in scene. The webView is used to make a request to www.wikipedia.com to receive informations about the geography of the discovered country.

<p align="center">
    <img src="Demo_gifs/show_country.gif"/>
</p>

To remember where was the last point that the user tapped on I create a pin node to give the user visual feedback.

<p align="center">
    <img src="Demo_gifs/pinnode.gif"/>
</p>
