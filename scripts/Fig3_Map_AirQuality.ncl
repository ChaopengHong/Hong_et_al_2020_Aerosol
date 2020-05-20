
   load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
   load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
   load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
   load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

   DataPath = "../data/"
   plotPath = "../Plots/"

   fs = addfile(DataPath+"SourceData.nc","r")

   Map = addfile(DataPath+"Map_d01.nc","r")
   lon = Map->XLONG(0,:,:)
   lat = Map->XLAT(0,:,:)
   nlon = dimsizes(lon)

   CountryFile = addfile(DataPath+"CountryMask_cn36.nc","r")
   CountryMask = CountryFile->MASK
   delete(CountryMask@_FillValue)

   do p=0,3

   if (p.eq.0) then
     var = "Fig3a_WeakenADE_PM25"
     LS = "PM~B3~2.5     concentration"
     RS = "~F33~m~F~g m~S~-3~N~"
   else if (p.eq.1) then
     var = "Fig3b_GlobalClimChg_PM25"
     LS = "PM~B3~2.5     concentration"
     RS = "~F33~m~F~g m~S~-3~N~"
   else if (p.eq.2) then
     var = "Fig3c_WeakenADE_O3max1h"
     LS = "Daily 1-h maximum ozone concentration"
     RS = "ppb"
   else if (p.eq.3) then
     var = "Fig3d_GlobalClimChg_O3max1h"
     LS = "Daily 1-h maximum ozone concentration"
     RS = "ppb"
   end if
   end if
   end if
   end if

   fon = plotPath+"/"+var
   XX = fs->$var$
   XX = where(CountryMask.gt.0,XX,0)
   Levels = (/-20,-10,-8,-5,-2,-1,-0.1,0.1,1,2,5,8,10,20/)
   clbdft = "BlueWhiteOrangeRed-CH"
   lbLabelStride = 1

   print(var)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   wks = gsn_open_wks("eps",fon)
   gsn_define_colormap(wks,clbdft)

   res = True
   res@gsnDraw = False
   res@gsnFrame = False
   res@gsnAddCyclic = False
   res@gsnSpreadColors = True
   res@cnFillOn = True
   res@cnLinesOn = False
   res@cnLineLabelsOn = False
   res@lbLabelFontHeightF = .016

   res@tmXBLabelFontHeightF = .016
   res@tmYLLabelFontHeightF = .016

   res@mpLimitMode = "Corners"
   res@mpLeftCornerLatF  = lat(0,0)
   res@mpLeftCornerLonF  = lon(0,0)
   res@mpRightCornerLatF = lat(nlon(0)-1,nlon(1)-1)
   res@mpRightCornerLonF = lon(nlon(0)-1,nlon(1)-1)
   res@mpProjection = "LambertConformal"
   res@mpLambertParallel1F = Map@TRUELAT1
   res@mpLambertParallel2F = Map@TRUELAT2
   res@mpLambertMeridianF = Map@CEN_LON

   res@mpDataSetName         = "Earth..4"
   res@mpDataBaseVersion     = "MediumRes"
   res@mpAreaMaskingOn            = True
   res@mpMaskAreaSpecifiers       = (/"China"/)
   res@mpOutlineSpecifiers        = (/"China","China:Provinces"/) ; corrected

   res@mpGridAndLimbOn = True
   res@mpGridLineDashPattern = 2
   res@mpGeophysicalLineThicknessF = 2
   res@tmXTOn = False
   res@tmYROn = False
   res@tmYLMinorOn = True

   res@pmTickMarkDisplayMode = "Always"
   res@lbOrientation = "Vertical"
   res@lbLabelStride = lbLabelStride

   res@cnInfoLabelSide = "Right"
   res@cnInfoLabelOrthogonalPosF = -1

   res@cnLevelSelectionMode = "ExplicitLevels"
   res@cnLevels = Levels

   res@tiDeltaF = 0.5
   res@tfDoNDCOverlay = True

   res@gsnLeftString = LS
   res@gsnRightString = RS
   res@gsnStringFontHeightF = .02
  
   res@tfDoNDCOverlay = True

   plot = gsn_csm_contour_map(wks,XX,res)
   draw(plot)
   frame(wks)

   end do

