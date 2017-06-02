PROGRAM mkmask
  !--------------------------------------------------------------------------------------
  !                            *** PROGRAM mkmask  ***
  !
  !        ** Purpose: add a vertical dimension to variable
  !
  !   History:
  !---------------------------------------------------------------------------------------
  USE netcdf
  IMPLICIT NONE

  INTEGER :: narg, iargc, jarg, ncol
  INTEGER :: n_bef, n_aft
  INTEGER :: npx, npy, npt, npk, jt, npz, ncidm
  CHARACTER(LEN=80) :: bdyfile, varname, cldum, cldum2, depname
  CHARACTER(LEN=1)  :: cobc, cvar
  REAL(KIND=4), DIMENSION (:,:), ALLOCATABLE ::  mask
  REAL(KIND=4), DIMENSION (:,:,:), ALLOCATABLE :: var2d
  REAL(KIND=4), DIMENSION (:,:,:,:), ALLOCATABLE :: var3d
  LOGICAL :: l2d, l3d

  ! Netcdf Stuff
  INTEGER :: istatus, ncid, id_x, id_y, idvar, id_t, id_dep
  INTEGER :: ncout, ids, idt, idep,idtim, ji, jj, idvarm
  ! * 
  narg=iargc()
  IF ( narg == 0 ) THEN
     PRINT *,' USAGE : mkmask NBDY var 2d/3d T/U/V: clean Northern BDY  '
     STOP
  ENDIF

  CALL getarg (1, bdyfile)
  CALL getarg (2, varname)
  CALL getarg (3, cldum)

  SELECT CASE ( cldum)
      CASE ( '2D' ) ; l2d = .TRUE.
      CASE ( '3D' ) ; l3d = .TRUE.
  END SELECT

  PRINT *,'2D = ', l2d
  PRINT *,'3D = ', l3d

  CALL getarg (4, cldum2)

  SELECT CASE ( cldum2)
      CASE ( 'T' ) ; depname='deptht'
      CASE ( 'U' ) ; depname='depthu'
      CASE ( 'V' ) ; depname='depthv'
  END SELECT


  istatus=NF90_OPEN(bdyfile,NF90_WRITE,ncid); PRINT *,'Open file :',NF90_STRERROR(istatus)

  istatus=NF90_INQ_DIMID(ncid,'x',id_x); PRINT *,'Inquire dimid :',NF90_STRERROR(istatus)
  istatus=NF90_INQUIRE_DIMENSION(ncid,id_x,len=npx)
  istatus=NF90_INQ_DIMID(ncid,'time_counter',id_t); PRINT *,'Inquire dimid :',NF90_STRERROR(istatus)
  istatus=NF90_INQUIRE_DIMENSION(ncid,id_t,len=npt)

  IF ( l3d ) THEN ; istatus=NF90_INQ_DIMID(ncid,depname,id_dep); PRINT *,'Inquire dimid :',NF90_STRERROR(istatus); istatus=NF90_INQUIRE_DIMENSION(ncid,id_dep,len=npk)
  ENDIF

  IF ( l2d ) THEN ; ALLOCATE( var2d(npx,1,npt) )
  ENDIF

  IF ( l3d ) THEN ; ALLOCATE( var3d(npx,1,npk,npt) )
  ENDIF

  istatus=NF90_INQ_VARID(ncid,varname,idvar); PRINT *,'Inquire varid :',NF90_STRERROR(istatus)
  IF ( l2d ) THEN ; istatus=NF90_GET_VAR(ncid,idvar,var2d); PRINT *,'Get var :',NF90_STRERROR(istatus)
  ENDIF
  IF ( l3d ) THEN ; istatus=NF90_GET_VAR(ncid,idvar,var3d); PRINT *,'Get var :',NF90_STRERROR(istatus)
  ENDIF
  istatus=NF90_OPEN('new_mask_BDYN.nc',NF90_WRITE,ncidm); PRINT *,'Open file :',NF90_STRERROR(istatus)

  ALLOCATE( mask(npx,1) )

  istatus=NF90_INQ_VARID(ncidm,'Bathymetry',idvarm); PRINT *,'Inquire varid :',NF90_STRERROR(istatus)
  istatus=NF90_GET_VAR(ncidm,idvarm,mask); PRINT *,'Get var :',NF90_STRERROR(istatus)


  IF ( l2d ) THEN

    DO ji = 1, npx
        IF ( mask(ji,1) < 1. )  var2d(ji,1,:) = 0.
    END DO

  ENDIF

  IF ( l3d ) THEN

    DO ji = 1, npx
        IF ( mask(ji,1) < 1. )  var3d(ji,1,:,:) = 0.
    END DO
  
  ENDIF

  IF ( l2d ) THEN ;  istatus=NF90_PUT_VAR(ncid,idvar,var2d); PRINT *,'Put var :',NF90_STRERROR(istatus)
  ENDIF
  IF ( l3d ) THEN ;  istatus=NF90_PUT_VAR(ncid,idvar,var3d); PRINT *,'Put var :',NF90_STRERROR(istatus)
  ENDIF
  istatus=NF90_CLOSE(ncid)
  istatus=NF90_CLOSE(ncidm)

  IF ( l2d ) THEN ;   DEALLOCATE(var2d, mask)
  ENDIF
  IF ( l3d ) THEN ;   DEALLOCATE(var3d, mask)
  ENDIF

END PROGRAM mkmask
