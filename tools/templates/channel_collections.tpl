# This file auto-generated by `generate_schema_interface.py`.
# Do not modify this file directly.

import traitlets as T
import pandas as pd

from .. import _interface as schema
from ..baseobject import BaseObject

{% for import_statement in objects|merge_imports -%}
  {{ import_statement }}
{% endfor %}

{% for cls in objects -%}
class {{ cls.name }}(schema.{{ cls.basename }}):
    """Object for storing channel encodings

    Attributes
    ----------
    {% for attr in cls.attributes -%}
    {{ attr.name }}: {{ attr.trait_descr }}
        {{ attr.short_description }}
    {% endfor -%}
    """
    {% for attr in cls.attributes -%}
    {{ attr.name }} = {{ attr.trait_fulldef }}
    {% endfor %}

    {%- set comma = joiner(", ") %}
    channel_names = [{% for attr in cls.attributes %}{{ comma() }}'{{ attr.name }}'{% endfor %}]

    skip = ['channel_names']

    def _finalize(self, data=None):
        """Finalize collection by inferring all types of contained channels"""
        if isinstance(data, pd.DataFrame):
            for attr in self.channel_names:
                val = getattr(self, attr)
                if val is not None:
                    val._finalize(data)


{% endfor -%}
