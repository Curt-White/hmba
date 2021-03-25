# hmba

### bma_tools (class)
This class holds basic tools to evaluate the motion estimation such as functions for HBMA, HexBS, image prediction, and plotting the images with their PSNR.

### hexbs.m
The exported function in this file produces a single motion vector with the HexBS algorithm

### hbma.m
The exported function of this file finds a complete set of motion vectors for the images passed in

### test.m
A simple example of how to use the functions in bma_tools. You shouldnt need to use the functions in hexbs.m or hmba.m directly

### Notes
 * I fear that there may be some confusion over the target and anchor frame naming. When passing in to the system, the anchor frame is the frame that we are trying to find a matching block for in the target frame. I may have gotten this backwards from what is mentioned in class.
 * The **tic** and **toc** functions can be used to time a given section of the code.