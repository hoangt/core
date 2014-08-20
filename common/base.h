// vim : set fileencoding=utf-8 expandtab noai ts=4 sw=4 :
/// @addtogroup common Common
/// @{
/// @file base.h
/// @date 2010-2014
/// @copyright All rights reserved.
///            Any reproduction, use, distribution or disclosure of this
///            program, without the express, prior written consent of the
///            authors is strictly prohibited.
/// @author Rolf Meyer
#ifndef COMMON_BASE_H_
#define COMMON_BASE_H_

#include "common/systemc.h"
#include "common/gs_config.h"
#include "common/report.h"

#ifndef MTI_SYSTEMC
// #include <greensocket/initiator/multi_socket.h>
#include <greenreg/greenreg.h>
#include <greenreg_ambasockets.h>
#endif

typedef sc_core::sc_module_name ModuleName;
typedef sc_core::sc_module DefaultBase;
typedef gs::reg::gr_device RegisterBase;

template<class BASE = DefaultBase>
class SCBaseModule : public BASE {
  public:
    SCBaseModule(ModuleName mn, uint32_t register_count = 0);
    virtual ~SCBaseModule() {}
};

template<class BASE = DefaultBase>
class BaseModule : public SCBaseModule<BASE> {
  public:
    BaseModule(ModuleName mn, uint32_t register_count) :
        SCBaseModule<BASE>(mn, register_count),
        m_generics("generics"),
        m_counters("counters"),
        m_power("power") {
      // m_api = gs::cnf::GCnf_Api::getApiInstance(self);
      DefaultBase *self = dynamic_cast<DefaultBase *>(this);
      if(self) {
        m_api = gs::cnf::GCnf_Api::getApiInstance(self);
      } else {
      srError("ConfigBaseModule")
        ("A ConfigBaseModule instance must also inherit from srBaseModule when it gets instantiated.");
      }
    }
    virtual ~BaseModule() {}
    
  protected:
    /// Internal module gs param api instance
     gs::cnf::cnf_api *m_api;

    /// Configuration generic container
    gs::cnf::gs_param_array m_generics;

    /// Performance counter container
    gs::cnf::gs_param_array m_counters;

    /// Power counters container
    gs::cnf::gs_param_array m_power;
};

#endif  // COMMON_BASE_H_
