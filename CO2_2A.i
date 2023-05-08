[Mesh]
  [file]
    type = FileMeshGenerator
    #file = 'task_2D.msh'
    file = 'Equilibration_out.e'
    use_for_exodus_restart = true
  []
[]

[GlobalParams]
  PorousFlowDictator = dictator
  gravity = '0 -9.81 0'
[]

[Variables]
  [pwater]
    #initial_condition = 27e6
    initial_from_file_var = pres_water
  []
  [sgas]
    initial_condition = 0.0
  []
  [temp]
    initial_condition = 773.15
    scaling = 1E-6 # fluid enthalpy is roughly 1E6
  []
[]

[AuxVariables]
  [massfrac_ph0_sp0]
    initial_condition = 1
  []
  [massfrac_ph1_sp0]
    initial_condition = 0
  []
  [massfrac_ph0_sp1]
  []
  [massfrac_ph1_sp1]
  []
  [pgas]
    family = MONOMIAL
    order = FIRST
  []
  [swater]
    family = MONOMIAL
    order = FIRST
  []
  [./density_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./density_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./viscosity_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./viscosity_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./enthalpy_gas]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./enthalpy_water]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [mass_water_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = pwater
  []
  [flux_water]
    type = PorousFlowAdvectiveFlux
    fluid_component = 0
    variable = pwater
    #gravity = '0 -9.81 0' # adding gravity for water and CO2
  []
  [mass_co2_dot]
    type = PorousFlowMassTimeDerivative
    fluid_component = 1
    variable = sgas
  []
  [flux_co2]
    type = PorousFlowAdvectiveFlux
    fluid_component = 1
    variable = sgas
   # gravity = '0 -9.81 0'
  []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = temp
  []
  [advection]
    type = PorousFlowHeatAdvection
    variable = temp
    #gravity = '0 -9.81 0'
  []
  [conduction]
    type = PorousFlowHeatConduction
    variable = temp
  []
[]

[AuxKernels]
  [pgas]
    type = PorousFlowPropertyAux
    property = pressure
    phase = 1
    variable = pgas
  []
  [swater]
    type = PorousFlowPropertyAux
    property = saturation
    phase = 0
    variable = swater
  []
  [./enthalpy_gas]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 1
    variable = enthalpy_gas
  [../]
  [./enthalpy_water]
    type = PorousFlowPropertyAux
    property = enthalpy
    phase = 0
    variable = enthalpy_water
  [../]
  [./density_water]
    type = PorousFlowPropertyAux
    property = density
    phase = 0
    variable = density_water
  [../]
  [./density_gas]
    type = PorousFlowPropertyAux
    variable = density_gas
    phase = 1
    property = density
  [../]
  [./viscosity_water]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 0
    variable = viscosity_water
  [../]
  [./viscosity_gas]
    type = PorousFlowPropertyAux
    property = viscosity
    phase = 1
    variable = viscosity_gas
  [../]
[]

[BCs]
  [side_pressure]
    type = DirichletBC
    variable = pwater
    value = 31e6
    boundary = 'TopBC'
  []
  [side_temperature]
    type = DirichletBC
    variable = temp
    value = 773.15
    boundary = 'TopBC BottomBC'
  []
  [injection_temperature]
    type = DirichletBC
    variable = temp
    value = 653.15
    boundary = 'InjectionPoint'
  []
[]

[DiracKernels] # Point source and point sink code/elements
  [fluid_injection]
    point = '800 525 0'
    mass_flux = 6E-3
    variable = sgas
    type = PorousFlowSquarePulsePointSource
  []
  [fluid_production]
    type = PorousFlowPeacemanBorehole
    variable = pwater
    SumQuantityUO = produced_mass_h2o
    point_file = 'well_out.bh'
    function_of = pressure
    fluid_phase = 0
    bottom_p_or_t = 30E6
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
    line_direction = '0 0 1'
    line_length = 1
  []
  [co2_production]
    type = PorousFlowPeacemanBorehole
    variable = sgas
    SumQuantityUO = produced_mass_co2
    point_file = 'well_out.bh'
    function_of = pressure
    fluid_phase = 1
    bottom_p_or_t = 30E6
    unit_weight = '0 0 0'
    use_mobility = true
    character = 1
    line_direction = '0 0 1'
    line_length = 1
  []
  [remove_heat_at_production_well_h2o]
    type = PorousFlowPeacemanBorehole
    variable = temp
    SumQuantityUO = produced_heat_h2o
    point_file = 'well_out.bh'
    function_of = pressure
    fluid_phase = 0
    bottom_p_or_t = 30E6
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
    line_direction = '0 0 1'
    line_length = 1
  []
  [remove_heat_at_production_well_co2]
    type = PorousFlowPeacemanBorehole
    variable = temp
    SumQuantityUO = produced_heat_co2
    point_file = 'well_out.bh'
    function_of = pressure
    fluid_phase = 1
    bottom_p_or_t = 30E6
    unit_weight = '0 0 0'
    use_mobility = true
    use_enthalpy = true
    character = 1
    line_direction = '0 0 1'
    line_length = 1
  []
[]

[UserObjects]
  #[soln] # to use conditions from Equilibration file
   # type = SolutionUserObject
   # mesh = Equilibration.e
   # system_variables = pwater
  #[]
  [produced_mass_h2o]
    type = PorousFlowSumQuantity
  []
  [produced_mass_co2]
    type = PorousFlowSumQuantity
  []
  [produced_heat_h2o]
    type = PorousFlowSumQuantity
  []
  [produced_heat_co2]
    type = PorousFlowSumQuantity
  []
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'temp pwater sgas'
    number_fluid_phases = 2
    number_fluid_components = 2
  []
  [pc]
    type = PorousFlowCapillaryPressureConst
    pc = 0
  []
[]

[Postprocessors]
  [heat_joules_extracted_this_timestep_h2o]
    type = PorousFlowPlotQuantity
    uo = produced_heat_h2o
    outputs = csv
  []
  [heat_joules_extracted_this_timestep_co2]
    type = PorousFlowPlotQuantity
    uo = produced_heat_co2
    outputs = csv
  []
  [mass_kg_h2o_extracted_this_timestep]
    type = PorousFlowPlotQuantity
    uo = produced_mass_h2o
    outputs = csv
  []
  [mass_kg_co2_extracted_this_timestep]
    type = PorousFlowPlotQuantity
    uo = produced_mass_co2
    outputs = csv
  []
  [Sg]
    type = PointValue
    point = '0 525 0'
    variable = sgas
  []
  [Sw]
    type = PointValue
    point = '0 525 0'
    variable = swater
  []
  [rhog]
    type = PointValue
    point = '0 525 0'
    variable = density_gas
  []
  [rhow]
    type = PointValue
    point = '0 525 0'
    variable = density_water
  []
  [temperature]
    type = PointValue
    point = '0 525 0'
    variable = temp
  []
  [mu_w]
    type = PointValue
    point = '0 525 0'
    variable = viscosity_water
  []
  [mu_g]
    type = PointValue
    point = '0 525 0'
    variable = viscosity_gas
  []
  [h_w]
    type = PointValue
    point = '0 525 0'
    variable = enthalpy_water
  []
  [h_g]
    type = PointValue
    point = '0 525 0'
    variable = enthalpy_gas
  []
[]

[Modules]
  [FluidProperties]
    [./water]
      type = Water97FluidProperties
    [../]
    [./co2]
      type = CO2FluidProperties
    [../]
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temp
  []
  [ppss]
    type = PorousFlow2PhasePS
    phase0_porepressure = pwater
    phase1_saturation = sgas
    capillary_pressure = pc
  []
  [massfrac]
    type = PorousFlowMassFraction
    mass_fraction_vars = 'massfrac_ph0_sp0 massfrac_ph1_sp0'
  []
  [water]
    type = PorousFlowSingleComponentFluid
    fp = water
    phase = 0
  []
  [gas]
    type = PorousFlowSingleComponentFluid
    fp = co2
    phase = 1
  []
  [relperm_liquid]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 0
    s_res = 0.1
    sum_s_res = 0.1
  []
  [relperm_gas]
    type = PorousFlowRelativePermeabilityCorey
    n = 2
    phase = 1
  []
  [porosity]
    type = PorousFlowPorosityConst # only the initial value of this is ever used
    porosity = 0.15
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    solid_bulk_compliance = 1E-10
    fluid_bulk_modulus = 2E9
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1e-14 0 0   0 1e-14 0   0 0 1e-14'
  []
  [thermal_expansion]
    type = PorousFlowConstantThermalExpansionCoefficient
    fluid_coefficient = 5E-6
    drained_coefficient = 2E-4
  []
  [thermal_conductivity]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '1 0 0  0 1. 0  0 0 1'
    wet_thermal_conductivity = '3 0 0  0 3. 0  0 0 3'
  []
  [rock_heat]
    type = PorousFlowMatrixInternalEnergy
    density = 2500.0
    specific_heat_capacity = 1200.0
  []
[]

[Preconditioning]
  active = preferred_but_might_not_be_installed
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 631152000.0 # 30y - 946728000.0 & 20y = 631152000.0
  nl_max_its = 25 # max Non linear iterations before cutback is applied
  l_max_its = 100
  dtmax = 31557600.0 # 1y
  dtmin = 100.0
  nl_abs_tol = 1e-6
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 86400
    growth_factor = 2 # if iterations is less than nl max --> if iteration runs smoothly
    cutback_factor = 0.5 # if iteration exceeds nl max --> runs poorly
  []
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
  []
[]
