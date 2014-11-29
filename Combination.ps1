$targetVersion = [version]"5.0.9883.0"
if($PSVersionTable.PSVersion -lt $targetVersion) {
    Write-Error "Sorry, you need PowerShell version $targetVersion or newer"
    break
}

class Combination {

    hidden [long]$n
    hidden [long]$k
    hidden [long[]]$data
    
    Combination([long]$n, [long]$k) {
    
        $this.n=$n
        $this.k=$k

        if($n -lt 0 -Or $k -lt 0) {throw "Negative argument in constructor"}

        $this.data=New-Object long[] $k
    
        for ($i = 0; $i -lt $k; ++$i)
        {
            $this.data[$i]=$i            
        }        
    }
    
    Combination([long]$n, [long]$k, [long[]]$a) {

        if($k -ne $a.Count) {throw "Bad array size in constructor"}

        $this.n=$n
        $this.k=$k

        $this.data=New-Object long[] $k
    
        for ($i = 0; $i -lt $k; ++$i)
        {
            $this.data[$i]=$a[$i]
        }        

    }

    [string]ToString() { return "{ "+ $this.data + " }" }

    static [long] Choose([long]$n, [long]$k) {
        [long]$delta=0
        [long]$iMax=0
        
        if($n -lt $k) { return 0 }
        if($n -eq $k) { return 1 }

        if($k -lt $n -$k) {
            $delta=$n-$k
            $iMax=$k
        } else {
            $delta=$k
            $iMax=$n-$k
        }

        [long]$answer = $delta + 1
        
        for ($i = 2; $i -le $iMax; ++$i)
        { 
            $answer = ($answer * ($delta + $i)) / $i
        }

        return $answer
    }

    [Combination] Successor() {

        if($this.data[0] -eq $this.n - $this.k) { return $null }

        [Combination]$ans = [Combination]::new($this.n, $this.k)
                
        for ($i = 0; $i -lt $this.k; ++$i)
        { 
            $ans.data[$i]=$this.data[$i]
        }

        for ($x = $this.k - 1; $x -gt 0 -and $ans.data[$x]  -eq $this.n-$this.k+$x; --$x) {}
         
        ++$ans.data[$x]        

        for ($j = $x; $j -lt $this.k - 1; ++$j)
        { 
            $ans.data[$j+1]=$ans.data[$j]+1
        }

        return $ans
    }
 
    [Combination] Element([long]$m) {

        [long[]] $ans = New-Object long[] $this.k
    
        [long]$a = $this.n;
        [long]$b = $this.k;
        [long]$x = ([Combination]::Choose($this.n, $this.k) - 1) - $m
 
        for ($i = 0; $i -lt $this.k; ++$i) 
        {
            $ans[$i] = [Combination]::LargestV($a,$b,$x)
            $x = $x - [Combination]::Choose($ans[$i],$b)
            $a = $ans[$i]
            $b = $b-1
        }

        for ($i = 0; $i -lt $this.k; ++$i)
        {
            $ans[$i] = ($this.n-1) - $ans[$i]
        }
      
        return [Combination]::new($this.n, $this.k, $ans)
    }

    hidden static [long] LargestV([long]$a, [long]$b, [long]$x) {
        
        $v = $a-1

        while([Combination]::Choose($v, $b) -gt $x) { --$v }
        
        return $v
    }

    [string[]] ApplyTo([string[]]$sa) {

        [string[]]$result=New-Object string[] $this.k
        
        for ($i = 0; $i -lt $result.Count; ++$i)
        { 
            $result[$i] = $sa[$this.data[$i]]
        }

        return $result
    }
}

function Get-Combination {
    param(        
        [string[]]$Data,
        [int]$TakeXAtAtime
    )

    $c = [Combination]::new($data.count, $TakeXAtAtime)
    while ($c) {
            
        $h=[ordered]@{}
        $idx=1
        $c.ApplyTo($data) | % {
            $h."Item$($idx)"=$_
            ++$idx
        }
        [PSCustomObject]$h
        $c=$c.Successor() 
    }    
}

$animals = echo ant bug cat dog elk
Get-Combination $animals 3 | Format-Table -AutoSize