# Beak TA3 Tools in Beaker-Kernel

This is a basic Beaker-Kernel setup to install and run the [Beak](https://github.com/DARPA-CRITICALMAAS/beak-ta3) library.

First, download the [data provided by the Beak team](https://drive.google.com/file/d/1r3rTzmcVvjqeOuB26OFanIADHrfc-Wa2/view?ts=65ccaf3e) and unzip it. Put it at the top level of this repo in a directory called `data`. You should see `data/BASE_RASTERS` etc. This is ~14GB.

Next, run `docker-compose up --build`. 

Once built you can navigate to `localhost:8080` select the `beak` context and try running a snippet. They seemed to only provide data to run [this example](https://github.com/DARPA-CRITICALMAAS/beak-ta3/blob/main/examples/notebooks/conversion_create_label_rasters.ipynb) which _runs_ but is unclear whether it produces the expected outputs.

Note that you need to change `BASE_PATH = files("beak.data")` to `BASE_PATH = files("data")`. They also have a broken import on `line 9` of the first cell which needs to be `from rasterio.enums import MergeAlg`.