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
#ifndef __itkSEMModuleParameterGroupSerializer_h
#define __itkSEMModuleParameterGroupSerializer_h

#include "ModuleParameterGroup.h"

#include "itkParameterSerializer.h"

#include "itkObjectFactory.h"

namespace itk
{

/** \class ModuleParameterGroup
 *
 * \brief An itk::LightObject proxy for the SEM ModuleParameterGroup class.
 *
 */
class ModuleDescriptionParser_EXPORT SEMModuleParameterGroup: public LightObject
{
public:
  using Self = SEMModuleParameterGroup;
  using Superclass = LightObject;
  using Pointer = SmartPointer< Self >;
  using ConstPointer = SmartPointer< const Self >;

  ITK_DISALLOW_COPY_AND_MOVE(SEMModuleParameterGroup);

  itkNewMacro( Self );

  void SetModuleParameterGroup( const ModuleParameterGroup & group )
    {
    this->m_ModuleParameterGroup = group;
    }

  const ModuleParameterGroup & GetModuleParameterGroup() const
    {
    return this->m_ModuleParameterGroup;
    }

  ModuleParameterGroup & GetModuleParameterGroup()
    {
    return const_cast< ModuleParameterGroup & >(
      static_cast< const SEMModuleParameterGroup & >(*this)
        .GetModuleParameterGroup() );
    }

protected:
  SEMModuleParameterGroup() = default;
  ~SEMModuleParameterGroup() override = default;

  ModuleParameterGroup m_ModuleParameterGroup;
};

/** \class SEMModuleParameterGroupSerializer
 *
 * \brief Parameter serializer for ITKModuleParameterGroup.
 *
 * \sa ParameterSerializer
 *
 */
class ModuleDescriptionParser_EXPORT SEMModuleParameterGroupSerializer:
  public ParameterSerializer
{
public:
  /** Standard class type aliases. */
  using Self = SEMModuleParameterGroupSerializer;
  using Superclass = ParameterSerializer;
  using Pointer = SmartPointer< Self >;
  using ConstPointer = SmartPointer< const Self >;

  ITK_DISALLOW_COPY_AND_MOVE(SEMModuleParameterGroupSerializer);

  /** Method for creation through the object factory. */
  itkNewMacro( Self );

  /** Run-time type information (and related methods). */
  itkOverrideGetNameOfClassMacro( SEMModuleParameterGroupSerializer );

  void Serialize() override;
  void DeSerialize() override;

protected:
  SEMModuleParameterGroupSerializer();
  ~SEMModuleParameterGroupSerializer() override;

  StringValue * m_Description;
  StringValue * m_Label;

  ParameterSerializerArrayValue * m_ModuleParameters;
};

} // end namespace itk

#endif
