BEGIN { FS=" ="; 
        REG1="DODEBUG|INCLUDE_RPC|DOPIC";
        REG2="DOLFS";
}
{  
   if ($0 ~ "^" REG1) 
     { print $1 " = false" } 
   else if ($0 ~ "^" REG2)
     { print $1 " = true" }
   else { print $0 } 
}
