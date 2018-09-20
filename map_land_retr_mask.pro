FUNCTION map_land_retr_mask, misr_path, misr_orbit, misr_block, $
   LAND_VERSION = land_version, VERBOSE = verbose, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function saves maps of the 36 land product
   ;  retrievability masks for the specified MISR PATH, ORBIT and BLOCK in
   ;  the standard location.
   ;
   ;  ALGORITHM: This function calls the function make_land_retr_mask to
   ;  generate the land retrievability masks and saves maps of these masks
   ;  in the standard location.
   ;
   ;  SYNTAX: rc = map_land_retr_mask(misr_path, misr_orbit, $
   ;  misr_block, LAND_VERSION = land_version, VERBOSE = verbose, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   misr_path {INTEGER} [I]: The selected MISR PATH number.
   ;
   ;  *   misr_orbit {LONG} [I]: The selected MISR ORBIT number.
   ;
   ;  *   misr_block {INTEGER} [I]: The selected MISR BLOCK number.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   LAND_VERSION = land_version {STRING} [I] (Default value: ’F08_0023’):
   ;      The L2 LAND version to use.
   ;
   ;  *   VERBOSE = VERBOSE {INT} [I] (Default value: 0): Flag to activate
   ;      (1) or skip (0) the printing of messages on the console about
   ;      where the maps are saved.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The maps of the 36 MISR L2 LAND
   ;      retrievability masks are saved in the standard location.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The maps of the 36 MISR L2 LAND retrievability masks
   ;      may be undefined, inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter misr_path is invalid.
   ;
   ;  *   Error 120: Input positional parameter misr_orbit is invalid.
   ;
   ;  *   Error 130: Input positional parameter misr_block is invalid.
   ;
   ;  *   Error 200: An exception condition occurred in path2str.pro.
   ;
   ;  *   Error 210: An exception condition occurred in orbit2str.pro.
   ;
   ;  *   Error 220: An exception condition occurred in block2str.pro.
   ;
   ;  *   Error 230: An exception condition occurred in
   ;      make_land_retr_mask.pro.
   ;
   ;  *   Error 400: The standard output folder for the maps is
   ;      unwritable.
   ;
   ;  *   Error 240: An exception condition occurred in is_writable.pro.
   ;
   ;  *   Error 250: An exception condition occurred in make_bytemap.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   block2str.pro
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   is_writable.pro
   ;
   ;  *   make_bytemap.pro
   ;
   ;  *   make_land_retr_mask.pro
   ;
   ;  *   orbit2str.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_misr_specs.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 65487
   ;      IDL> misr_block = 110
   ;      IDL> rc = map_land_retr_mask(misr_path, misr_orbit, misr_block, $
   ;         /VERBOSE, /DEBUG, EXCPT_COND = excpt_cond)
   ;      The L2 Land retrievability mask for camera DF and
   ;         spectral band Blue has been saved in
   ;         ~/MISR_HR/Outcomes/P168_O065487_B110/L2LA/
   ;            Retr_mask_P168_O065487_B110_DF_Blue.png.
   ;      ...
   ;      The L2 Land retrievability mask for camera DA and
   ;         spectral band NIR has been saved in
   ;         ~/MISR_HR/Outcomes/P168_O065487_B110/L2LA/
   ;         Retr_mask_P168_O065487_B110_DA_NIR.png.
   ;      IDL>
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–18: Version 0.9 — Initial release.
   ;
   ;  *   2018–09–20: Version 1.0 — Initial public release.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;Sec-Cod

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   IF (KEYWORD_SET(verbose)) THEN verbose = 1 ELSE verbose = 0

   ;  If the MISR L2 Land version number is not specified, use 'F08_0023':
   IF (~KEYWORD_SET(land_version)) THEN land_version = 'F08_0023'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, misr_orbit, misr_block.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_path' is invalid:
      rc = chk_misr_path(misr_path, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_orbit' is invalid:
      rc = chk_misr_orbit(misr_orbit, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'misr_block' is invalid:
      rc = chk_misr_block(misr_block, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the MISR specifications:
   misr_specs = set_misr_specs()
   cam_names = misr_specs.CameraNames
   num_cams = misr_specs.NCameras
   bnd_names = misr_specs.BandNames
   num_bnds = misr_specs.NBands

   ;  Set the standard locations for MISR and MISR-HR files on this computer:
   root_dirs = set_root_dirs()

   ;  Generate the string version of the MISR Path number:
   rc = path2str(misr_path, misr_path_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Orbit number:
   rc = orbit2str(misr_orbit, misr_orbit_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Generate the string version of the MISR Block number:
   rc = block2str(misr_block, misr_block_str, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF ((debug) AND (rc NE 0)) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   pob_str = misr_path_str + '_' + misr_orbit_str + '_' + misr_block_str

   ;  Generate the MISR L2 Land retrievability mask for the selected MISR Path,
   ;  Orbit and Block:
   rc = make_land_retr_mask(misr_path, misr_orbit, misr_block, $
      land_retr_mask, LAND_VERSION = land_version, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (debug AND (rc NE 0)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Set the colors to use for the land retrievability mask:
   good_vals_l2r = [0B, 1B, 255B]
   good_vals_blu_l2r = ['black', 'blue', 'orange']
   good_vals_grn_l2r = ['black', 'green', 'orange']
   good_vals_red_l2r = ['black', 'red', 'orange']
   good_vals_nir_l2r = ['black', 'purple', 'orange']

   ;  Set the output folder address and check that it is writable:
   save_path = root_dirs[3] + pob_str + '/L2LA/'
   rc = is_writable(save_path, DEBUG = debug, EXCPT_COND = excpt_cond)
   CASE rc OF
      0: BEGIN
         error_code = 400
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The output folder ' + save_path + ' is unwritable.'
         RETURN, error_code
      END
      -1: BEGIN
         IF (debug) THEN BEGIN
            error_code = 240
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
      END
      -2: BEGIN
         FILE_MKDIR, save_path
      END
      ELSE: BREAK
   ENDCASE

   ;  Loop over the MISR cameras:
   FOR cam = 0, num_cams - 1 DO BEGIN

   ;  Loop over the MISR cameras:
      FOR bnd = 0, num_bnds - 1 DO BEGIN

   ;  Map the L2 retrievability mask for the current camera and spectral band:
         save_file = 'Retr_mask_' + pob_str + '_' + cam_names[cam] + $
            '_' + bnd_names[bnd] + '.png'
         save_spec = save_path + save_file
         retr_msk = REFORM(land_retr_mask[cam, bnd, *, *])
         CASE bnd OF
            0: rc = make_bytemap(retr_msk, good_vals_l2r, good_vals_blu_l2r, $
               save_spec, /DEBUG, EXCPT_COND = excpt_cond)
            1: rc = make_bytemap(retr_msk, good_vals_l2r, good_vals_grn_l2r, $
               save_spec, /DEBUG, EXCPT_COND = excpt_cond)
            2: rc = make_bytemap(retr_msk, good_vals_l2r, good_vals_red_l2r, $
               save_spec, /DEBUG, EXCPT_COND = excpt_cond)
            3: rc = make_bytemap(retr_msk, good_vals_l2r, good_vals_nir_l2r, $
               save_spec, /DEBUG, EXCPT_COND = excpt_cond)
            ELSE: BREAK
         ENDCASE
         IF (rc NE 0) THEN BEGIN
            error_code = 250
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, error_code
         ENDIF
         IF (verbose) THEN BEGIN
            PRINT, 'The L2 Land retrievability mask for camera ' + $
               cam_names[cam] + ' and spectral band ' + bnd_names[bnd] + $
               ' has been saved in ' + save_spec + '.'
         ENDIF
      ENDFOR
   ENDFOR

   RETURN, return_code
END
