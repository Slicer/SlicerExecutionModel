
// ModuleDescriptionParser includes
#include "ModuleDescription.h"

// STD includes
#include <cstdlib>
#include <string>

//---------------------------------------------------------------------------
bool TestReadParameterFileWithMissingValue();

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

  if (!TestReadParameterFileWithMissingValue())
    {
    return EXIT_FAILURE;
    }

  return EXIT_SUCCESS;
}

//---------------------------------------------------------------------------
bool TestReadParameterFileWithMissingValue()
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
    return false;
    }

  if (!desc.ReadParameterFile(input))
    {
    std::cerr << "Line " << __LINE__
              << " - 'SUVMean' set to a new value. Modification are expected."
              << std::endl;
    return false;
    }

  if (!desc.HasParameter("OutputLabel") || !desc.HasParameter("SUVMean"))
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Parameters are expected."
              << std::endl;
    return false;
    }

  if (desc.GetParameterDefaultValue("OutputLabel") != "")
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Value is expected to be empty."
              << std::endl;
    return false;
    }

  if (desc.GetParameterDefaultValue("SUVMean") != "2")
    {
    std::cerr << "Line " << __LINE__
              << " - Problem reading parameters - Value is expected to be '2'."
              << std::endl;
    return false;
    }

  return true;
}
