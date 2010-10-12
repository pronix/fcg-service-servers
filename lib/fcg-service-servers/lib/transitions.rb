# Based on http://github.com/qoobaa/transitions/raw/master/lib/active_record/transitions.rb
# Copyright (c) 2009 Rick Olson

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require "transitions"

module FCG::Model
  module Transitions
    module InstanceMethods
      protected
      def write_state(state_machine, state)
        self.state = state.to_s
        save!
      end

      def read_state(state_machine)
        self.state.to_sym
      end

      def set_initial_state
        self.state ||= self.class.state_machine.initial_state.to_s
      end

      def state_inclusion
        unless self.class.state_machine.states.map{|s| s.name.to_s }.include?(self.state.to_s)
          self.errors.add(:state, :inclusion, :value => self.state)
        end
      end
    end

    def self.included(receiver)
      receiver.extend         ActiveSupport::Concern
      receiver.send :include, ::Transitions
      receiver.send :include, InstanceMethods
      receiver.before_validation :set_initial_state
      receiver.validates_presence_of :state
      receiver.validate :state_inclusion
      receiver.field :state, :type => String
      receiver.attr_protected :state
    end
  end
end