class EventManager
  
  attr_accessor :event
  
  def handle_event(event)
    self.send(event["event"].to_sym, event)
    self
  end
  
  def kiwi_identity(event)
    event_name = event["event"]
    party_url = event["party"]["_links"]["self"]["href"]
    event["party"]["name"] = get_party(url: party_url)["name"]
    @event = Event.create_event(name: event_name, party_url: party_url, event: event)
  end
  
  def account_creation(event)
    event_name = event["event"]
    party_url = event["party"]["_links"]["self"]["href"]
    event["party"]["name"] = get_party(url: party_url)["name"]    
    @event = Event.create_event(name: event_name, party_url: party_url, event: event)    
  end
  
  def authorisation_event(event)
    event_name = event["event"]
    party_url = event["party"]["_links"]["self"]["href"]
    event["party"]["name"] = get_party(url: party_url)["name"]    
    @event = Event.create_event(name: event_name, party_url: party_url, event: event)    
  end    
  
  def txn_event(event)
    event_name = event["event"]
    party_url = event["party"]["_links"]["self"]["href"]
    event["party"]["name"] = get_party(url: party_url)["name"]
    @event = Event.create_event(name: event_name, party_url: party_url, event: event)        
  end

  def party_change(event)
    event_name = event["event"]
    party_url = event["party"]["_links"]["self"]["href"]
    @event = Event.create_event(name: event_name, party_url: party_url, event: event)        
  end

  
  def get_party(url: nil)
    CustomerPort.new.get_customer(url: url).party["party"]
  end
  
  def port_event(event)
    event_name = event["event"]
    @event = Event.create_event(name: event_name, party_url: nil, event: event)            
  end
  
=begin
  
EVENTS
======
  
Kiwi Identity
-------------

    {
      event: "kiwi_identity",
      timestamps: {
        identity_validation_time: Time.now
      },
      party: {
        _links: {
          self: {
            href: self.party_url
          }
        }        
      },
      ref: [
        {
          link: self.party_url,
          ref: "party"
        },
        {
          ref: :sub,
          id: self.user_proxy["id_token"]["sub"] 
        },
        {
          link: url_helpers.kiwi_url(self, host: Setting.services(:self, :host)),
          ref: "kiwi"
        }
      ],
      id_token: {
        sub: self.user_proxy["id_token"]["sub"]
      }
    }
  
  
Account Creation  
----------------  
{
  event: "account_creation",
  timestamps: {
    account_create_time: self.created_at
  },
  sales_product: {
    _links: {
      self: {
        href: self.sales_product_url
      }
    }
  },
  transaction_account: {
    type: self.type,      
    _links: {
      self: {
        href: url_helpers.api_v1_account_url(self, host: Setting.services(:self,:host))
      }
    }        
    
  },
  party: {
    _links: {
      self: {
        href: self.party_url
      }
    }        
  }  
}
  
OAUTH Authorisation Event
-------------------------
  
    {
      event: "authorisation_event",
      status: :success
      timestamps: {
        expires_time: self.expires_in,
        create_time: self.time_created
      }
      client: {
        client_id: self.client.client_id,
        client_name: self.client.client_name
      },
      user: {
        name: self.user.name
      }
      party: {
        _links: {
          self: {
            href: self.user.reference_for(ref: :party).link
          }
        }
      }
    }

Transaction Event
-----------------  
    {
      event: "txn_event",
      timestamps: {
        transaction_time: self.created_at
      },
      transaction: {
        bus_op: self.bus_op,
        amount: self.amount,
        desc: self.desc
      },
      party: {
        _links: {
          self: {
            href: self.transaction_account.party_url
          }
        }
      },
      account: {
        type: self.transaction_account.type
        _links: {
          self: {
            href: url_helpers.api_v1_account(self.transaction_account)
          }
        }        
      }     
    }


Party Change Event
------------------

    {
      kind: "party_change",
      party: {
        name: self.name,
        age: self.age
        _links: {
          self: {
            href: url_helpers.api_v1_party(self, host: Setting.services(:self, :host))
          }
        }
      }
    }



=end
  

  
  
  
end