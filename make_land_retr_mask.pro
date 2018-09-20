FUNCTION make_land_retr_mask, misr_path, misr_orbit, misr_block, $
   land_retr_mask, LAND_VERSION = land_version, DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a mask indicating where the standard
   ;  MISR L2 LAND product is deemed retrievable given the outcome of the
   ;  cloud and aerosol processing.
   ;
   ;  ALGORITHM: This function reads the field Suitable_For_Land_Retrieval
   ;  from the NetCDF formatted MISR L2 LAND product corresponding to the
   ;  selected misr_path, misr_orbit and misr_block, and returns a mask in
   ;  the output parameter land_retr_mask, at the spatial resolution of
   ;  1100 m, indicating where the atmosphere is clear enough to retrieve
   ;  the standard land surface product.
   ;
   ;  SYNTAX:
   ;  rc = make_land_retr_mask, misr_path, misr_orbit, misr_block, $
   ;  land_retr_mask, LAND_VERSION = land_version, $
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
   ;  *   land_retr_mask {BYTE array [9, 4, 512, 128]} [O]: The mask
   ;      indicating where the atmosphere is clear enough to retrieve the
   ;      MISR standard land surface product.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   LAND_VERSION = land_version {STRING} [I] (Default value: ’F08_0023’):
   ;      The version identifier of the MISR L2 LAND product.
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
   ;      provided in the call. The output positional parameter
   ;      land_retr_mask contain(s) the desired mask, where each pixel
   ;      value can take on one of the following values:
   ;
   ;      -   0: Unsuitable.
   ;
   ;      -   1: Suitable.
   ;
   ;      -   255: Fill value.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter land_retr_mask may be
   ;      undefined, inexistent, incomplete or useless.
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
   ;  *   Error 300: An exception condition occurred in the MISR TOOLKIT
   ;      routine
   ;      MTK_MAKE_FILENAME.
   ;
   ;  *   Error 400: The MISR L2 LAND file implied by the input positional
   ;      parameters does not exist or can be found in more than one
   ;      place.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   MISR Toolkit
   ;
   ;  *   chk_misr_block.pro
   ;
   ;  *   chk_misr_orbit.pro
   ;
   ;  *   chk_misr_path.pro
   ;
   ;  *   path2str.pro
   ;
   ;  *   set_root_dirs.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function only works with MISR L2 LAND product
   ;      versions equal to or posterior to ’F08_0023’.
   ;
   ;  *   NOTE 2: The field Suitable_For_Land_Retrieval in the NetCDF
   ;      formatted MISR L2 LAND product file is defined as a short
   ;      (8-bit, signed) integer, which does not exist as a data type in
   ;      IDL: upon reading, its value is converted to type BYTE. However,
   ;      since the latter is unsigned, the decimal value -1 in the
   ;      original file (used for fill), equivalent to the binary value
   ;      11111111, is read as a decimal value 255B in the output mask.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> misr_path = 168
   ;      IDL> misr_orbit = 65487
   ;      IDL> misr_block = 110
   ;      IDL> rc = make_land_retr_mask(misr_path, misr_orbit, misr_block, $
   ;         land_retr_mask, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ', rc
   ;      rc =        0
   ;
   ;  REFERENCES:
   ;
   ;  *   Michael J. Garay, Michael A. Bull, Marcin L. Witek, Abigail M.
   ;      Nastan, Felix C. Seidel, David J. Diner, Ralph A. Kahn, James A.
   ;      Limbacher, Olga V. Kalashnikova (2018) _Data Product
   ;      Specification for the MISR Level 2 Land Surface Product_, NASA
   ;      JPL D-100650, 22 pp. [See, in particular, the documentation for
   ;      the field Suitable_For_Surface_Retrieval, on p. 17].
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–10: Version 0.8 — Initial release by Linda Hunt.
   ;
   ;  *   2018–08–20: Version 0.9 — Documented version.
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

   ;  If the MISR L2 Land version number is not specified, use 'F08_0023':
   IF (~KEYWORD_SET(land_version)) THEN land_version = 'F08_0023'

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): misr_path, misr_orbit, misr_block, ' + $
            'land_retr_mask.'
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

   ;  Set the path to the MISR L2 Land file:
   land_path = root_dirs[1] + misr_path_str + PATH_SEP() + 'L2_LA/'

   ;  Select the MISR L2 Land product to read:
   land_product = 'AS_LAND'

   ;  Generate the MISR L2 Land file name corresponding to the
   ;  positional parameters:
   misr_path_s = STRING(misr_path, FORMAT = '(I03)')
   misr_orbit_s = STRING(misr_orbit, FORMAT = '(I06)')
   status = MTK_MAKE_FILENAME(land_path, land_product, '', misr_path_s, $
      misr_orbit_s, land_version, land_file)
   IF (debug AND (status NE 0)) THEN BEGIN
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Status from MTK_MAKE_FILENAME = ' + strstr(status)
      RETURN, error_code
   ENDIF

   ;  Substitute the '.hdf' for the '.nc' suffix:
   land_file = FILE_BASENAME(land_file, '.hdf') + '.nc'

   ;  Remove any wildcard character:
   f = FILE_SEARCH(land_path + land_file, COUNT = cntf)
   IF (debug AND (cntf NE 1)) THEN BEGIN
      error_code = 400
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input file ' + land_path + land_file + ' does not exist or ' + $
         'can be found in more than one place.'
      RETURN, error_code
   ENDIF
   land_file = f[0]

   ;  Open the NetCDF formatted MISR L2 Land file and get the retrievability
   ;  mask (See Note 2 above):
   fid = NCDF_OPEN(land_file, /NOWRITE)
   resgid = NCDF_NCIDINQ(fid, '1.1_KM_PRODUCTS')
   auxgid = NCDF_NCIDINQ(resgid, 'AUXILIARY')
   varid = NCDF_VARID(auxgid, 'Suitable_For_Surface_Retrieval')
   NCDF_VARGET, auxgid, varid, lr_mask

   ;  Get the MISR Block start locations from the attributes of the
   ;  1.1_KM_PRODUCTS group:
   bsxvarid = NCDF_VARID(resgid, 'Block_Start_X_Index')
   bsyvarid = NCDF_VARID(resgid, 'Block_Start_Y_Index')
   NCDF_VARGET, resgid, bsxvarid, bsx
   NCDF_VARGET, resgid, bsyvarid, bsy

   ;  Get the MISR Block number of the first Block of data in this Orbit:
   NCDF_ATTGET, fid, 'Start_block', start_block, /GLOBAL

   ;  Create 2 arrays of indexes to hold the x and y start positions for each
   ;  of the 180 MISR Blocks in the full data array, and calculate the position
   ;  of the specified Block within the full Orbit data array (the SOM X axis
   ;  direction is along-track and the SOM Y direction is across-track):
   block_xidx = LONARR(180)
   block_xidx[start_block - 1] = bsx
   block_yidx = LONARR(180)
   block_yidx[start_block - 1] = bsy

   ;  Extract the data for the desired Block from the full data array:
   land_retr_mask = lr_mask[*, *, $
      block_yidx[misr_block - 1]:block_yidx[misr_block - 1] + 511, $
      block_xidx[misr_block - 1]:block_xidx[misr_block] - 1]

   RETURN, return_code

END
