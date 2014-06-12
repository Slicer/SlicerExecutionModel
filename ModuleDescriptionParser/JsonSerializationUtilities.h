/*=========================================================================

  Copyright 2014 Kitware, Inc. All Rights Reserved.

  See COPYRIGHT.txt
  or http://www.slicer.org/copyright/copyright.txt for details.

  Program:   JSON Serialization Utilities
  Module:    $HeadURL$
  Date:      $Date$
  Version:   $Revision$

==========================================================================*/

#ifndef __JsonSerializationUtilities_h
#define __JsonSerializationUtilities_h

#include <json/json.h>

namespace {

void ReadJsonParameter( const Json::Value & parameter, int & value )
{ value = parameter.asInt(); }

void ReadJsonParameter( const Json::Value & parameter, unsigned int & value )
{ value = parameter.asUInt(); }

void ReadJsonParameter( const Json::Value & parameter, float & value )
{ value = parameter.asFloat(); }

void ReadJsonParameter( const Json::Value & parameter, double & value )
{ value = parameter.asDouble(); }

void ReadJsonParameter( const Json::Value & parameter, bool & value )
{ value = parameter.asBool(); }

void ReadJsonParameter( const Json::Value & parameter, std::string & value )
{ value = parameter.asString(); }

template <typename T>
void ReadJsonParameter( const Json::Value & parameter, std::vector<T> & value )
{
  const Json::ArrayIndex k = parameter.size();
  value.resize( k );
  for( Json::ArrayIndex i = 0; i < k; ++i )
    {
    ReadJsonParameter( parameter[i], value[i] );
    }
}

template <typename T>
void ReadJsonParameter(
  const Json::Value & parameters,
  const char * group, const char * name,
  T & value)
{
  const Json::Value & parameter = parameters[group][name];
  if( !parameter.isNull() )
    {
    ReadJsonParameter( parameter, value );
    }
}

template <typename T>
Json::Value JsonSerialize( const T & value )
{ return value; }

template <typename T>
Json::Value JsonSerialize( const std::vector<T> & value )
{
  Json::Value array( Json::arrayValue );
  const size_t k = value.size();
  for( size_t i = 0; i < k; ++i )
    {
    array.append( JsonSerialize( value[i] ) );
    }
  return array;
}

}

#endif
