# bl_app_dbb_AntsCTSeg

This application implement a custumed version of [_AntsCorticalThickness.sh_ script](https://github.com/ANTsX/ANTs/blob/master/Scripts/antsCorticalThickness.sh), using [PTBP priors](https://figshare.com/articles/dataset/The_Pediatric_Template_of_Brain_Perfusion_PTBP_/923555)  and  a brain mask  to obtain the brain tissue segmentation.

### Author

    Gabriele Amorosino (gamorosino@fbk.eu)

## Running the Brainlife App


You can run the BrainLife App `DBB_ANTsCortThickSeg` on the brainlife.io platform via the web user interface (UI) or using the `brainlife CLI`.  With both of these two solutions, the inputs and outputs are stored on the brainlife.io platform, under the specified project, and the computations are performed using the brainlife.io cloud computing resources.


### On Brainlife.io via UI

You can see _DBB_ANTsCortThickSeg_ currently registered on Brainlife. Find the App on _brainlife.io_ and click "Execute" tab and specify dataset e.g. "DBB Distorted Brain Benchmark".

### On Brainlife.io using CLI

Brainlife CLI could be installed on UNIX/Linux-based system following the instruction reported in https://brainlife.io/docs/cli/install/.

you can run the App with CLI as follow:
```
bl app run --id   60ef07acddc2dff22965f239  --project <project_id> --input t0:<t1_object_id> --input mask:<mask_object_id> 
```
the output is stored in the reference project specified with the id ```<project_id>```. You can retrieve the _object_id_ using the command ```bl data query```, e.g to get the id of the mask file for the subject _0001_ :
```
bl data query --subject 0001 --datatype neuro/mask --project <projectid>
```

If not present yet, you can upload a new file in a project using ```bl data upload```. For example, in the case of T1-w file, for the subject 0001 you can run:
```
bl data upload --project <project_id> --subject 0001 --datatype "neuro/anat/t1w" --t1 <full_path>

```
## Running the code locally

You can run the code on your local machine by git cloning this repository. You can choose to run it with _dockers_, avoiding to install any software except for [singularity](https://sylabs.io/). Furthermore, you can run the original script using local software installed.

### Run the script using the dockers (recommended)

It is possible to run the app locally, using the dockers that embedded all needed software. This is exactly the same way that apps run code on brainlife.io

Inside the cloned directory, create `config.json` with something like the following content with the fullpaths to your local input files:
```
{   
    "t1": "./t1.nii.gz",
    "mask": "./mask.nii.gz"
}
```

Launch the app by executing `main`.
```
./main
```
To avoid using the config file, you can input directly the fullpath of the filess using the script ```main.sh```:

```
main.sh <t1.ext> <mask.ext> [<outputdir>]
```

#### Script Dependecies

The App needs   `singularity` to run.

#### Output

The output of _bl_app_dbb_ANTnCTSeg_ are the predicted segmentation volume of the 3D U-Net and a json file describing the labels of the segmented volume.         

The files are stored in the working directory, under the folder _./segmentation_  with the name _segmentation.nii.gz_ , for the semgnetaion volume and _label.json_, for the json file.

#### Run test on DBB Distorted Brain testset

You can run the tool to reproduce the results on the test set of DBB Distorted Brain Benchmark using the scritp:
```
run_test.sh <outputdir>
```

The script performs the download of the published dataset of the DBB benchmark (https://doi.org/10.25663/brainlife.pub.24) and predict the segmentation volume for each subjects. Furthermore, compute the dice score using the published groundtruth and create the final _csv_ file reporting the dice score for each label of the segmented volumes.