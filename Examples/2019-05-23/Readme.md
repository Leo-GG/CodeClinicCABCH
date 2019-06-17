# Fourth session

No real problems to fix on this one, so I cleaned up a bit some old demo code for Calcium Imaging image (video) analysis. The code is meant to be just a toy example of the possibilities for image analysis in MATLAB (and in no ways meant to be the best approach for this particular problem).

The code reads a stack of separated images that compose a video of a Calcium imaging experiment.
Cells that are active (i.e. that have changes in their calcium concentrations) should show changes in fluorescence. Thus, the intensity change is calculated between each pair of consecutive images. The background is subtracted from the mean (in time, or actually time differences) of these differences using an adaptative threshold. Then local maxima are located and merged using hierarchical clustering (I left code for kMeans clustering or for considering every maxima commented out). Finally, small clusters are filtered out to remove possible artifacts.

