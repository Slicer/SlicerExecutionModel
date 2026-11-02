/*=========================================================================

Library:   TubeTK

Copyright 2010 Kitware Inc. 28 Corporate Drive,
Clifton Park, NY, 12065, USA.

All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=========================================================================*/
#ifndef __itkSEMModuleDescriptionSerializer_h
#define __itkSEMModuleDescriptionSerializer_h

#include "ModuleDescription.h"

#include "itkParameterSerializer.h"

#include "itkObjectFactory.h"

namespace itk
{

/** \class ModuleDescription
 *
 * \brief An itk::LightObject proxy for the SEM ModuleDescription class.
 *
 */
class ModuleDescriptionParser_EXPORT SEMModuleDescription: public LightObject
{
public:
  using Self = SEMModuleDescription;
  using Superclass = LightObject;
  using Pointer = SmartPointer< Self >;
  using ConstPointer = SmartPointer< const Self >;

  ITK_DISALLOW_COPY_AND_MOVE(SEMModuleDescription);

  itkNewMacro( Self );

  void SetModuleDescription( const ModuleDescription & module )
    {
    this->m_ModuleDescription = module;
    }

  const ModuleDescription & GetModuleDescription() const
    {
    return this->m_ModuleDescription;
    }

  ModuleDescription & GetModuleDescription()
    {
    return const_cast< ModuleDescription & >(
      static_cast< const SEMModuleDescription & >(*this)
        .GetModuleDescription() );
    }

protected:
  SEMModuleDescription() = default;
  ~SEMModuleDescription() override = default;

  ModuleDescription m_ModuleDescription;
};

/** \class SEMModuleDescriptionSerializer
 *
 * \brief Parameter serializer for ITKModuleDescription.
 *
 * \sa ParameterSerializer
 *
 */
class ModuleDescriptionParser_EXPORT SEMModuleDescriptionSerializer:
  public ParameterSerializer
{
public:
  /** Standard class type aliases. */
  using Self = SEMModuleDescriptionSerializer;
  using Superclass = ParameterSerializer;
  using Pointer = SmartPointer< Self >;
  using ConstPointer = SmartPointer< const Self >;

  ITK_DISALLOW_COPY_AND_MOVE(SEMModuleDescriptionSerializer);

  /** Method for creation through the object factory. */
  itkNewMacro( Self );

  /** Run-time type information (and related methods). */
  itkOverrideGetNameOfClassMacro( SEMModuleDescriptionSerializer );

  void Serialize() override;
  void DeSerialize() override;

protected:
  SEMModuleDescriptionSerializer();
  ~SEMModuleDescriptionSerializer() override;

  StringValue * m_Category;
  StringValue * m_Contributor;
  StringValue * m_Description;
  StringValue * m_DocumentationURL;
  StringValue * m_License;
  StringValue * m_Title;
  StringValue * m_Version;

  ParameterSerializerArrayValue * m_ParameterGroups;
};

} // end namespace itk

#endif
