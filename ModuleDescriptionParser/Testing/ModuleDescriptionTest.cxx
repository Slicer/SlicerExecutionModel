
// ModuleDescriptionParser includes
#include "ModuleDescription.h"
#include "ModuleDescriptionTestingMacros.h"

// STD includes
#include <cstdlib>
#include <string>

//---------------------------------------------------------------------------
int TestReadParameterFileWithMissingValue();
int TestParameterFileWithPointFile();

//---------------------------------------------------------------------------
namespace
{
  std::string INPUT_DIR;
}

//---------------------------------------------------------------------------
int ModuleDescriptionTest(int argc, char * argv[])
{
  if (argc < 2)
    {
    std::cout << "Usage: " << argv[0] << " /path/to/inputs" << std::endl;
    return EXIT_FAILURE;
    }

  INPUT_DIR = std::string(argv[1]);

  CHECK_EXIT_SUCCESS(TestReadParameterFileWithMissingValue());
  CHECK_EXIT_SUCCESS(TestParameterFileWithPointFile());

  return EXIT_SUCCESS;
}

//---------------------------------------------------------------------------
int TestReadParameterFileWithMissingValue()
{
  std::string input = INPUT_DIR
      + "/parameter-file-with-missing-value-slicer-issue2712.params";

  ModuleParameterGroup group;

  {
    ModuleParameter parameter;
    parameter.SetName("OutputLabel");
    group.AddParameter(parameter);
  }

  {
    ModuleParameter parameter;
    parameter.SetName("SUVMean");
    group.AddParameter(parameter);
  }

  ModuleDescription desc;
  desc.AddParameterGroup(group);

  if (!desc.HasParameter("OutputLabel") || !desc.HasParameter("SUVMean"))
    {
    std::cerr << "Line " << __LINE__
              << " - Parameters are expected."
              << std::endl;
    return EXIT_FAILURE;
    }

  if (!desc.ReadParameterFile(input))
    {
    std::cerr << "Line " << __LINE__
              << " - 'SUVMean' set to a new value. Modification are expected."
              << std::endl;
    return EXIT_FAILURE;
    }

  if (!desc.HasParameter("OutputLabel") || !desc.HasParameter("SUVMean"))
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Parameters are expected."
              << std::endl;
    return EXIT_FAILURE;
    }

  if (desc.GetParameterDefaultValue("OutputLabel") != "")
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Value is expected to be empty."
              << std::endl;
    return EXIT_FAILURE;
    }

  if (desc.GetParameterDefaultValue("SUVMean") != "2")
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Value is expected to be '2'."
              << std::endl;
    return EXIT_FAILURE;
    }

  return EXIT_SUCCESS;
}

//---------------------------------------------------------------------------
int TestParameterFileWithPointFile()
{
  std::string input = INPUT_DIR
      + "/parameter-file-with-pointfile-slicer-issue2979.params";

  ModuleParameterGroup group;

  {
    ModuleParameter parameter;
    parameter.SetName("Input Fiducial File");
    parameter.SetDefault("input.fcsv");
    parameter.SetTag("pointfile");
    parameter.SetMultiple("false");
    parameter.SetFileExtensionsAsString(".fcsv");
    parameter.SetCoordinateSystem("ras");
    parameter.SetChannel("input");
    group.AddParameter(parameter);
  }

  {
    ModuleParameter parameter;
    parameter.SetName("Output Fiducial File");
    parameter.SetDefault("output.fcsv");
    parameter.SetTag("pointfile");
    parameter.SetMultiple("false");
    parameter.SetFileExtensionsAsString(".fcsv");
    parameter.SetCoordinateSystem("lps");
    parameter.SetChannel("output");
    group.AddParameter(parameter);
  }

  ModuleDescription desc;
  desc.AddParameterGroup(group);

  if (!desc.HasParameter("Input Fiducial File") || !desc.HasParameter("Output Fiducial File"))
    {
    std::cerr << "Line " << __LINE__
              << " - Parameters are expected."
              << std::endl;
    return EXIT_FAILURE;
    }
  if (!desc.WriteParameterFile(input, true))
    {
    std::cerr << "Line " << __LINE__
              << " - Unable to write parameter file "
              << input
              << std::endl;
    return EXIT_FAILURE;
    }

  ModuleDescription readDesc;
  if (readDesc.ReadParameterFile(input))
    {
    std::cerr << "Line " << __LINE__
              << " - Unable to read parameter file, something changed"
              << ", but it was reading into an empty description "
              << input
              << std::endl;
    return EXIT_FAILURE;
    }

  return EXIT_SUCCESS;
}
