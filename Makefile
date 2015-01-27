.SUFFIXES: .F .o

OBJS = 	mpas_li_mpas_core.o \
	mpas_li_time_integration.o \
	mpas_li_time_integration_fe.o \
	mpas_li_diagnostic_vars.o \
	mpas_li_tendency.o \
	mpas_li_setup.o \
	mpas_li_velocity.o \
	mpas_li_sia.o \
	mpas_li_mask.o

all: core_landice

core_landice: $(OBJS)
	ar -ru libdycore.a $(OBJS)

core_reg:
	$(CPP) $(CPPFLAGS) $(CPPINCLUDES) Registry.xml > Registry_processed.xml

core_input_gen:
	if [ ! -e default_inputs ]; then  mkdir default_inputs; fi
	(cd default_inputs; $(NL_GEN) ../Registry_processed.xml namelist.landice )
	(cd default_inputs; $(ST_GEN) ../Registry_processed.xml streams.landice stream_list.landice. )

post_build:
	if [ ! -e $(ROOT_DIR)/default_inputs ]; then mkdir $(ROOT_DIR)/default_inputs; fi
	cp default_inputs/* $(ROOT_DIR)/default_inputs/.
	( cd $(ROOT_DIR)/default_inputs; for FILE in `ls -1`; do if [ ! -e ../$$FILE ]; then cp $$FILE ../.; fi; done )

mpas_li_mpas_core.o: mpas_li_time_integration.o \
                     mpas_li_setup.o \
                     mpas_li_velocity.o \
                     mpas_li_diagnostic_vars.o \
                     mpas_li_mask.o

mpas_li_setup.o:

mpas_li_time_integration.o: mpas_li_time_integration_fe.o

mpas_li_time_integration_fe.o: mpas_li_velocity.o \
                               mpas_li_tendency.o \
                               mpas_li_diagnostic_vars.o \
                               mpas_li_setup.o

mpas_li_tendency.o: mpas_li_setup.o

mpas_li_diagnostic_vars.o: mpas_li_mask.o \
                           mpas_li_velocity.o

mpas_li_velocity.o: mpas_li_sia.o \
                    mpas_li_setup.o

mpas_li_sia.o: mpas_li_mask.o \
               mpas_li_setup.o

mpas_li_mask.o: mpas_li_setup.o

clean:
	$(RM) *.o *.mod *.f90 libdycore.a
	$(RM) Registry_processed.xml
	@# Certain systems with intel compilers generate *.i files
	@# This removes them during the clean process
	$(RM) *.i
	$(RM) -r default_inputs

.F.o:
	$(RM) $@ $*.mod
	$(CPP) $(CPPFLAGS) $(CPPINCLUDES) $< > $*.f90
	$(FC) $(FFLAGS) -c $*.f90 $(FCINCLUDES) -I../framework -I../operators -I../external/esmf_time_f90
