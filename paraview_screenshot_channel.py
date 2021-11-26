#### import the simple module from the paraview
from paraview.simple import *
import sys

def screenshot(fn_in, fn_out, vmin, vmax, colormap='BuGn'):
    #### disable automatic camera reset on 'Show'
    paraview.simple._DisableFirstRenderCameraReset()

    # create a new 'XML Unstructured Grid Reader'
    uvtu = XMLUnstructuredGridReader(FileName=[fn_in])
    uvtu.CellArrayStatus = ['Label', 'tensor1']

    # get active view
    renderView1 = GetActiveViewOrCreate('RenderView')
    # uncomment following to set a specific view size
    # renderView1.ViewSize = [2075, 1177]

    # get color transfer function/color map for 'Label'
    labelLUT = GetColorTransferFunction('Label')

    # get opacity transfer function/opacity map for 'Label'
    labelPWF = GetOpacityTransferFunction('Label')

    # show data in view
    uvtuDisplay = Show(uvtu, renderView1)
    # trace defaults for the display properties.
    uvtuDisplay.Representation = 'Surface'
    uvtuDisplay.ColorArrayName = ['CELLS', 'Label']
    uvtuDisplay.LookupTable = labelLUT
    uvtuDisplay.OSPRayScaleArray = 'Label'
    uvtuDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
    uvtuDisplay.SelectOrientationVectors = 'None'
    uvtuDisplay.ScaleFactor = 0.2
    uvtuDisplay.SelectScaleArray = 'Label'
    uvtuDisplay.GlyphType = 'Arrow'
    uvtuDisplay.GlyphTableIndexArray = 'Label'
    uvtuDisplay.DataAxesGrid = 'GridAxesRepresentation'
    uvtuDisplay.PolarAxes = 'PolarAxesRepresentation'
    uvtuDisplay.ScalarOpacityFunction = labelPWF
    uvtuDisplay.ScalarOpacityUnitDistance = 0.013375650489415542

    # reset view to fit data
    renderView1.ResetCamera()

    #changing interaction mode based on data extents
    renderView1.InteractionMode = '2D'
    renderView1.CameraPosition = [1.0, 0.5, 10000.0]
    renderView1.CameraFocalPoint = [1.0, 0.5, 0.0]

    # show color bar/color legend
    uvtuDisplay.SetScalarBarVisibility(renderView1, True)

    # update the view to ensure updated data information
    renderView1.Update()

    # set scalar coloring
    ColorBy(uvtuDisplay, ('CELLS', 'tensor1', 'Magnitude'))

    # Hide the scalar bar for this color map if no visible data is colored by it.
    HideScalarBarIfNotNeeded(labelLUT, renderView1)

    # rescale color and/or opacity maps used to include current data range
    uvtuDisplay.RescaleTransferFunctionToDataRange(True, False)

    # show color bar/color legend
    uvtuDisplay.SetScalarBarVisibility(renderView1, True)

    # get color transfer function/color map for 'tensor1'
    tensor1LUT = GetColorTransferFunction('tensor1')

    # Hide orientation axes
    renderView1.OrientationAxesVisibility = 0

    # hide color bar/color legend
    uvtuDisplay.SetScalarBarVisibility(renderView1, False)

    # rescale color and/or opacity maps used to exactly fit the current data range
    uvtuDisplay.RescaleTransferFunctionToDataRange(False, True)

    # Rescale transfer function
    tensor1LUT.RescaleTransferFunction(vmin, vmax)

    # get opacity transfer function/opacity map for 'tensor1'
    tensor1PWF = GetOpacityTransferFunction('tensor1')

    # Rescale transfer function
    tensor1PWF.RescaleTransferFunction(vmin, vmax)

    # Apply a preset using its name. Note this may not work as expected when presets have duplicate names.
    tensor1LUT.ApplyPreset(colormap, True)

    # current camera placement for renderView1
    renderView1.InteractionMode = '2D'
    renderView1.CameraPosition = [1.0, 0.5, 10000.0]
    renderView1.CameraFocalPoint = [1.0, 0.5, 0.0]
    renderView1.CameraParallelScale = 0.6311010395633536

    # save screenshot
    SaveScreenshot(fn_out, renderView1, ImageResolution=[2070, 1176],
        TransparentBackground=1)

fn_in = sys.argv[1]
fn_out = sys.argv[2]
vmin = float(sys.argv[3])
vmax = float(sys.argv[4])

print('fn_in: ', fn_in)
print('fn_out: ', fn_out)
print('vmin: ', vmin)
print('vmax: ', vmax)

screenshot(fn_in, fn_out, vmin, vmax)
